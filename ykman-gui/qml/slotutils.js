function slotName(slotNumber) {
    if (slotNumber === 1)
        return "short press"
    if (slotNumber === 2)
        return "long press"
}

function slotNameCapitalized(slotNumber){
    if (slotNumber === 1)
        return "Short Press"
    if (slotNumber === 2)
        return "Long Press"
}

function configuredTxt(configured) {
    return configured ? "configured" : "not configured"
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}
