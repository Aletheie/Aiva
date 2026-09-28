plugins { java }
group = "cz.aiva.practice"
version = "1.0.0"
repositories { mavenCentral() }
java { toolchain { languageVersion = JavaLanguageVersion.of(21) } }
tasks.withType<JavaCompile>().configureEach { options.release.set(8) }
dependencies {
 testImplementation(platform("org.junit:junit-bom:5.12.2"))
 testImplementation("org.junit.jupiter:junit-jupiter")
 testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}
tasks.test { useJUnitPlatform(); enabled = false }
