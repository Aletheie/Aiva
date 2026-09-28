class Message {
    public String text() {
        return "Zpráva";
    }
}

class Welcome extends Message {
    @Override
    public String text() {
        return "Vítej";
    }

    public String language() {
        return "čeština";
    }
}

class Reminder extends Message {
    @Override
    public String text() {
        return "Čas na procvičení";
    }
}

public class Main {
    public static void main(String[] args) {
        Message[] messages = {new Welcome(), new Reminder()};
        for (Message message : messages) {
            System.out.println(message.text());
        }
        Message first = messages[0];
        if (first instanceof Welcome welcome) {
            System.out.println(welcome.language());
        }
    }
}
