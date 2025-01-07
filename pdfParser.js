const fs = require('fs');
const pdfParse = require('pdf-parse');

async function parseResume(filePath) {
    const dataBuffer = fs.readFileSync(filePath);

    try {
        const pdfData = await pdfParse(dataBuffer);
        const text = pdfData.text;

        // Extract Personal Details
        const name = text.match(/(?<=Name:\s).+/i)?.[0] || "Not Found";
        const phoneNumber = text.match(/\b\d{10}\b/)?.[0] || "Not Found";
        const email = text.match(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/)?.[0] || "Not Found";
        const address = text.match(/(?<=Address:\s).+/i)?.[0] || "Not Found";

        // Extract Link Details
        const linkedIn = text.match(/https?:\/\/(www\.)?linkedin\.com\/[^\s]+/i)?.[0] || "Not Found";
        const github = text.match(/https?:\/\/(www\.)?github\.com\/[^\s]+/i)?.[0] || "Not Found";
        const portfolio = text.match(/https?:\/\/[^\s]+/i)?.[0] || "Not Found";

        // Extract Educational Details
        const matriculation = text.match(/Matriculation\s?:\s?(.+),\sYear:\s?(\d{4}),\sGrade:\s?([\w.]+)/i);
        const matriculationDetails = matriculation ? {
            schoolName: matriculation[1],
            year: matriculation[2],
            grade: matriculation[3],
        } : "Not Found";

        const intermediate = text.match(/Intermediate\s?:\s?(.+),\sYear:\s?(\d{4}),\sBranch:\s?([\w\s]+),\sGrade:\s?([\w.]+)/i);
        const intermediateDetails = intermediate ? {
            schoolName: intermediate[1],
            year: intermediate[2],
            branch: intermediate[3],
            grade: intermediate[4],
        } : "Not Found";

        const university = text.match(/University\s?:\s?(.+),\sYear:\s?(\d{4}),\sBranch:\s?([\w\s]+),\sGrade:\s?([\w.]+)/i);
        const universityDetails = university ? {
            universityName: university[1],
            year: university[2],
            branch: university[3],
            grade: university[4],
        } : "Not Found";

        // Extract Work Experience
        const workExperience = [...text.matchAll(/Company:\s?(.+?),\sField:\s?(.+?),\sDuration:\s?(.+?),\sLocation:\s?(.+)/g)].map(match => ({
            companyName: match[1],
            field: match[2],
            duration: match[3],
            location: match[4],
        }));

        return {
            personalDetails: { name, phoneNumber, email, address },
            linkDetails: { linkedIn, github, portfolio },
            education: { matriculationDetails, intermediateDetails, universityDetails },
            workExperience: workExperience.length ? workExperience : "Not Found",
        };
    } catch (error) {
        console.error("Error parsing PDF:", error);
        return null;
    }
}
