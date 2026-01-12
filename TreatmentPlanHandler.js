// File: TreatmentPlanHandler.js

function checkAndAdvanceStage() {
    // Prompt the user for advancing the treatment plan
    const userResponse = window.confirm("Do you want to advance the treatment plan to the next stage?");

    if (userResponse) {
        // User wants to advance the plan
        advanceToNextStage();
    } else {
        // User does not want to advance; reset the current plan start date
        const twoWeeksFromNow = new Date();
        twoWeeksFromNow.setDate(twoWeeksFromNow.getDate() + 14);
        currentPlanStartDate = twoWeeksFromNow;
        alert(`The current plan has been retained. The start date has been reset to ${twoWeeksFromNow.toLocaleDateString()}.`);
    }
}

function advanceToNextStage() {
    // Logic to advance to the next stage
    console.log("Advancing to the next stage of the treatment plan...");
}

// Assume currentPlanStartDate is a global variable
let currentPlanStartDate = new Date();