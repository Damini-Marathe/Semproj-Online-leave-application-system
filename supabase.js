// ==========================================================
// Supabase Client Configuration
// ==========================================================

const SUPABASE_URL = "https://pfvqssaixfqimmkhwtrx.supabase.co";
const SUPABASE_KEY = "sb_publishable_bKStMdErEUVRaolffEwQQA_VfYLC8pJ";

// Initialize Supabase Client if library is loaded
let supabaseClient = null;

if (typeof supabase !== "undefined" && typeof supabase.createClient === "function") {
    supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_KEY);
} else {
    console.warn("Supabase library not yet loaded. Ensure @supabase/supabase-js is included before supabase.js");
}

// Make accessible globally
window.supabaseClient = supabaseClient;
window.SUPABASE_URL = SUPABASE_URL;
window.SUPABASE_KEY = SUPABASE_KEY;
