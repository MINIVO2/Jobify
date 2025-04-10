package in.sp.register;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import okhttp3.*; // Make sure okhttp3 dependency is added

@WebServlet("/GeminiSuggestServlet")
public class GeminiSuggestServlet extends HttpServlet {
    private static final String API_KEY = "AIzaSyAu-gbR2rWjW_5cpLKfIoL_mxIYmlymp5A";
    private static final String GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" + API_KEY;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");

        OkHttpClient client = new OkHttpClient();

        // Gemini Prompt Setup
        JsonObject prompt = new JsonObject();
        JsonObject part = new JsonObject();
        part.addProperty("text", "Suggest 5 job search suggestions based on: " + query);

        JsonArray parts = new JsonArray();
        parts.add(part);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject data = new JsonObject();
        data.add("contents", contents);

        // Request
        RequestBody body = RequestBody.create(
                new Gson().toJson(data),
                MediaType.parse("application/json")
        );

        Request geminiRequest = new Request.Builder()
                .url(GEMINI_URL)
                .post(body)
                .build();

        // Response from Gemini
        try (Response geminiResponse = client.newCall(geminiRequest).execute()) {
            String geminiResult = geminiResponse.body().string();

            // Extract suggestions from response
            List<String> suggestions = new ArrayList<>();

            if (geminiResult.contains("candidates")) {
                JsonObject json = new Gson().fromJson(geminiResult, JsonObject.class);
                String textResponse = json.getAsJsonArray("candidates")
                        .get(0).getAsJsonObject()
                        .get("content").getAsJsonObject()
                        .getAsJsonArray("parts").get(0).getAsJsonObject()
                        .get("text").getAsString();

                // Example response: "1. Software Developer\n2. Data Analyst\n..."
                for (String line : textResponse.split("\n")) {
                    suggestions.add(line.replaceAll("^[0-9]+\\.", "").trim());
                }
            }

            // Send suggestions as JSON
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();

            JsonObject result = new JsonObject();
            result.add("suggestions", new Gson().toJsonTree(suggestions));
            out.print(result);
            out.flush();
        }
    }

    public static class ApplyJobServlet {
    }
}
