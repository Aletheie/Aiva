# Otestuj oznámení, aniž bys budila celý chat

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Klubový chat právě oslavuje Nelino sedmnácté dokončení téže zkušební lekce. Ema posílá poslední gratulaci a pak vypíná upozornění. Nela by mezitím potřebovala opravit ještě jedinou větu v oznámení.

Připraví si proto způsob doručení, který zprávu jen zaznamená pro kontrolu. Aplikace má dál oznamovat stejný úspěch, ale během testu bez skutečných příjemkyň. Příští opravdová oslava si zaslouží, aby ji po sérii zkoušek ještě někdo slyšel.

</details>
<!-- aiva-story:end -->

Nela ladí oznámení o dokončené lekci. Při každém pokusu chce zkontrolovat text zprávy, ne opravdu upozornit všechny kamarádky. Pomoz jí vyměnit způsob doručení.

Implementuj `RecordingNotifier`: jeho `send(String message)` uloží text do pole `lastMessage` a getter ho vrátí. Předej ho `CourseService`, zavolej `finishLesson()` a ověř uloženou zprávu `Lekce dokončena`.

Samotnou službu neměň. Hotovo je, když stejná operace funguje s původním oznamovačem i s tvým záznamem do paměti.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Služba zůstala beze změny.
- Send uloží předaný text.
- Příklad funguje i bez skutečného externího odesílání.
