import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class Main {
    static String forecast(HttpClient client, URI uri) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder(uri)
                .timeout(Duration.ofSeconds(2)).GET().build();
        HttpResponse<String> response = client.send(request,
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        if (response.statusCode() == 200) return "Predpoved: " + response.body().strip();
        if (response.statusCode() == 404) return "Misto nenalezeno";
        return "Sluzba nedostupna: " + response.statusCode();
    }

    public static void main(String[] args) throws Exception {
        try (LocalWeatherServer server = new LocalWeatherServer();
             HttpClient client = HttpClient.newBuilder()
                     .connectTimeout(Duration.ofSeconds(2)).build()) {
            System.out.println(forecast(client, server.uri("/shire")));
            System.out.println(forecast(client, server.uri("/unknown")));
            System.out.println(forecast(client, server.uri("/mordor")));
        }
    }
}
