// src/ListingService.js

const BASE_URL = "https://hackathon-bu-deploy-4.onrender.com"; // Deployed backend URL

export const fetchListings = async () => {
    try {
        const response = await fetch(`${BASE_URL}/listings/uid`);
        if (!response.ok) {
            throw new Error("Failed to fetch listings");
        }
        const data = await response.json();
        console.log("Fetched listings:", data); // Log the response
        return data.uids; // Assuming you just want the UIDs for now
    } catch (error) {
        console.error(error);
        throw error;
    }
};

export const fetchListingDetails = async (uid) => {
    try {
        const response = await fetch(`${BASE_URL}/listing/${uid}`);
        if (!response.ok) {
            throw new Error("Failed to fetch listing details");
        }
        const data = await response.json();
        return data;
    } catch (error) {
        console.error(error);
        throw error;
    }
};
