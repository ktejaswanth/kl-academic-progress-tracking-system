package com.example.demo.service.ai;

import com.example.demo.dto.curriculum.CurriculumAnalysisResult;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.util.retry.Retry;

import java.time.Duration;
import java.util.List;
import java.util.Map;

@Service
public class GeminiService {

    private static final Logger log = LoggerFactory.getLogger(GeminiService.class);

    @Value("${gemini.api.key:}")
    private String apiKey;

    @Value("${gemini.api.model:gemini-2.0-flash}")
    private String model;

    @Value("${gemini.api.url:https://generativelanguage.googleapis.com/v1beta}")
    private String baseUrl;

    @Autowired
    private PromptBuilder promptBuilder;

    private final Gson gson = new Gson();

    /**
     * Checks if the exception is retryable (429 Too Many Requests or 5xx Server Error).
     */
    private boolean isRetryable(Throwable throwable) {
        if (throwable instanceof WebClientResponseException) {
            WebClientResponseException ex = (WebClientResponseException) throwable;
            log.warn("Gemini API call failed. Status Code: {}, Error Response: {}", 
                    ex.getStatusCode(), ex.getResponseBodyAsString());
            return ex.getStatusCode().value() == 429 || ex.getStatusCode().is5xxServerError();
        }
        return false;
    }

    /**
     * Analyzes extracted curriculum text using the Gemini API.
     * Returns the raw JSON string from Gemini.
     */
    public String analyzeRaw(String extractedText, String department, String regulation) {
        if (apiKey == null || apiKey.isBlank()) {
            throw new RuntimeException("GEMINI_API_KEY is not configured. Set it in .env or application.properties.");
        }

        String systemPrompt = promptBuilder.buildSystemPrompt();
        String userPrompt = promptBuilder.buildUserPrompt(extractedText, department, regulation);

        // Build Gemini API request body
        Map<String, Object> requestBody = Map.of(
            "system_instruction", Map.of(
                "parts", List.of(Map.of("text", systemPrompt))
            ),
            "contents", List.of(
                Map.of("parts", List.of(Map.of("text", userPrompt)))
            ),
            "generationConfig", Map.of(
                "temperature", 0.1,
                "maxOutputTokens", 65536,
                "responseMimeType", "application/json"
            )
        );

        String url = baseUrl + "/models/" + model + ":generateContent?key=" + apiKey;

        log.info("Calling Gemini API with model: {}", model);
        log.info("Extracted text length: {} characters", extractedText.length());

        WebClient client = WebClient.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(10 * 1024 * 1024))
                .build();

        String responseBody = client.post()
                .uri(url)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(String.class)
                .retryWhen(Retry.backoff(3, Duration.ofSeconds(15))
                        .filter(this::isRetryable)
                        .doBeforeRetry(retrySignal -> log.warn("Gemini API call failed with rate limit (429) or server error (5xx). Retrying... Attempt #{}", 
                                retrySignal.totalRetries() + 1)))
                .timeout(Duration.ofMinutes(5))
                .block();

        log.info("Gemini API response received, length: {} characters",
                responseBody != null ? responseBody.length() : 0);

        return extractJsonFromResponse(responseBody);
    }

    /**
     * Analyzes extracted curriculum text and parses the result into a DTO.
     */
    public CurriculumAnalysisResult analyze(String extractedText, String department, String regulation) {
        String rawJson = analyzeRaw(extractedText, department, regulation);
        return parseResult(rawJson);
    }

    /**
     * Parses the raw JSON string into a CurriculumAnalysisResult DTO.
     */
    public CurriculumAnalysisResult parseResult(String json) {
        try {
            return gson.fromJson(json, CurriculumAnalysisResult.class);
        } catch (JsonSyntaxException e) {
            log.error("Failed to parse Gemini JSON response: {}", e.getMessage());
            log.error("Raw JSON: {}", json);
            throw new RuntimeException("Failed to parse AI response as valid curriculum data. " +
                    "The AI may have returned malformed JSON. Error: " + e.getMessage());
        }
    }

    /**
     * Extracts the JSON content from the Gemini API response envelope.
     * The response has structure: { candidates: [{ content: { parts: [{ text: "..." }] } }] }
     */
    private String extractJsonFromResponse(String responseBody) {
        if (responseBody == null || responseBody.isBlank()) {
            throw new RuntimeException("Empty response from Gemini API");
        }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> response = gson.fromJson(responseBody, Map.class);

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> candidates = (List<Map<String, Object>>) response.get("candidates");
            if (candidates == null || candidates.isEmpty()) {
                // Check for error
                if (response.containsKey("error")) {
                    @SuppressWarnings("unchecked")
                    Map<String, Object> error = (Map<String, Object>) response.get("error");
                    throw new RuntimeException("Gemini API error: " + error.get("message"));
                }
                throw new RuntimeException("No candidates in Gemini API response");
            }

            @SuppressWarnings("unchecked")
            Map<String, Object> content = (Map<String, Object>) candidates.get(0).get("content");
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> parts = (List<Map<String, Object>>) content.get("parts");

            String text = (String) parts.get(0).get("text");

            // Remove markdown code fences if present (shouldn't be with responseMimeType=json, but just in case)
            text = text.trim();
            if (text.startsWith("```json")) {
                text = text.substring(7);
            } else if (text.startsWith("```")) {
                text = text.substring(3);
            }
            if (text.endsWith("```")) {
                text = text.substring(0, text.length() - 3);
            }

            return text.trim();
        } catch (JsonSyntaxException e) {
            log.error("Failed to parse Gemini API response envelope: {}", e.getMessage());
            throw new RuntimeException("Invalid response format from Gemini API: " + e.getMessage());
        }
    }
}
