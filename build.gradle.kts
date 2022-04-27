import jp.skypencil.flix.FlixCompile
import jp.skypencil.flix.FlixTest
plugins {
    id("jp.skypencil.flix-base") version "1.1.2"
}

val compileFlix = tasks.register<FlixCompile>("compileFlix") {
    source = fileTree("src")
    destinationDirectory.set(file("build/classes/flix/main"))
}
val testFlix = tasks.register<FlixTest>("testFlix") {
    source = fileTree("test")
    destinationDirectory.set(file("build/classes/flix/test"))
    report.set(file("build/reports/flix/main.txt"))
}

tasks.named<Task>("assemble") { dependsOn(compileFlix) }
tasks.named<Task>("check") { dependsOn(testFlix) }
