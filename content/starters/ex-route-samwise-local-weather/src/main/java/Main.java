import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class Main {
    static String forecast(HttpClient client, URI uri) throws IOException, InterruptedException {
        // TODO: GET, timeout, status a teprve potom obsah.
        return "Predpoved: ceka se";
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
