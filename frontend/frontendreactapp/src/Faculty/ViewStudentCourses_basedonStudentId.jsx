import React from "react";
import StudentLookupView from "../components/StudentLookupView";

export default function ViewStudentCoursesBasedOnStudentId() {
    return <StudentLookupView endpointPrefix="/faculty" />;
}
