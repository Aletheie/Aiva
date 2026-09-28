import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class GreetingServiceTest {
    @Test
    void greetsKnownUser() {
        NameRepository repository = mock(NameRepository.class);
        when(repository.findName(7)).thenReturn("Ada");
        GreetingService service = new GreetingService(repository);

        String actual = service.greet(7);

        assertEquals("Ahoj, Ada", actual);
        verify(repository).findName(7);
    }
}
