README für das Projekt GameServer (Angepasst an Implementierung von Cannon)

Dieses Projekt dient als Einstieg in die Implementierungsaufgabe (HA2 SWTPP WS 2017/2018). 

Die Aufgabe soll als Servlet auf einem Apache Tomcat Web-Server abgeliefert werden. In eclipse ist dies 
ein "dynamic web project". 

Im Folgenden wird ein Überblick über die schon vorgegebenen Ressourcen 
gegeben. Danach folgen noch ein paar Erklärungen zur Funktionsweise des Servlets. Außerdem sollten 
die Kommentare in den bestehenden Dateien beachtet werden. Hier sind auch noch einige Hinweise zu finden.

1) Projekt-Überblick
--------------------

---| GameServer
   Der übergeordnete Projekt-Ordner. Hier befinden sich die Eclipse-Konfiguration und die Projekt-Dateien, 
   außerdem natürlich alle im Folgenden beschriebenen Ordner.
   
   ---| src
      Hier befinden sich alle reinen Java-Source-Code-Dateien, aufgeteilt in packets. In eclipse sind die 
      packets als Ganzes zu sehen (getrennt mit Punkten). Im Dateisystem sind das jeweils Unter-Ordner.
   
      ---| de.tuberlin.sese.swtpp.gameserver.control
         Packet für die Controller-Klassen des Klassenmodells.
         
      ---| de.tuberlin.sese.swtpp.gameserver.model
         Packet für die Entity-Klassen des akstrakten Klassenmodells, d.h. das eigentliche Datenmodell des 
         Servers ohne konkrete Spiel-Implementierung

      ---| de.tuberlin.sese.swtpp.gameserver.model.cannon
         Packet für die Entity-Klassen des Klassenmodells, d.h. das Datenmodell des konkreten Spiels Cannon
         
      ---| de.tuberlin.sese.swtpp.gameserver.test.cannon
         Hier befinden sich die jUnit Testcases und Testsuiten, die von euch anzupassen sind.
         
      ---| de.tuberlin.sese.swtpp.gameserver.swtpp.web
         Hier befindet sich die Klasse GameServerServlet, welche die zentrale Komponente in die Web-Anwendung auf Server-Seite ist. 
         Zu dem Servlet später mehr.
         
   ---| build
      Hier landen die kompilierten Klassen
      
   ---| WebContent
      In diesem Ordner werden die Web-Ressourcen des Projekts gespeichert, die der Apache Tomcat Server dann wie 
      ein Web-Server zur Verfügung stellt. Bilder, html-Seiten, css-Dateien sind also über eine URL erreichbar (je nach ProjektName
      z.B. http://localhost:8080/GameServerServlet/...) mit dem Pfad innerhalb dieses Ordners erreichbar. Wenn die Ressource
      innerhalb einer Page auf dem Tomcat verlinkt wird kann auch mit einem relativen Pfad gearbeitet werden. Z.B. <a href="meinbild.jpg">Bild</>
  
2) Implementierungsaufgabe

Wir haben die Web-Funktionalität in dem gegebenen Projekt schon erledigt. Die Interaktion mit den Requests ist also für alle Use-Cases bereits erledigt. Die GUI (HTML/Javascript) 
für den Client-Browser) ist auch bereits erledigt. Das Gleiche gilt für die Server-Verwaltung, das abstrakte Spiel und einen großen Teil des Cannon-Spiels. Für euch bleibt nur die Implementierung einiger 
Funktionen in der CannonGame und die dazugehörigen Tests. Bestehender Code darf nicht geändert werden. 
Zur Orientierung und Erklärung der bereits erledigten Anteile dienen die beiden folgenden Kapitel.   
  
3) Das Servlet

Ein Servlet ist ein "Behältnis" für eine dynamische Web Anwendung, die auf einem Application Server wie dem Apache Tomcat 
ausgeführt werden kann. Kern davon ist das Servlet (in unserem Fall GameServerServlet), diese Klasse implementiert die Klasse HttpServlet 
und ist im deployment descriptor (Konfiguration des Projekts) registriert. Hierdurch wird dem Apache 
Web Server signalisiert, dass er das Servlet für HTTP-requests bereit stellen soll. Alle Anfragen (HTTP requests) des
Benutzers an die URL des Servlets (http://localhost:8080/GameServer/GameServerServlet) werden an die Servlet-Klasse weitergeleitet.
Die Anfragen im Beispiel werden an die doGet()-Methode von GameServerServlet weitergeleitet.

Wichtig: 
Die Servlet-Klasse wird einmal vom Server erstellt. Egal welcher Benutzer/welche Session/welcher Browser etc. - man landet immer in dieser
Servlet-Klasse. Die Attribute sind also immer sichtbar. Sie eignen sich nur für globale Variablen und die Daten, die nicht vom aktuellen Zustand der
Session eines Benutzers abhängen.

3) Die Client-Seite

Die Client-Seite besteht in diesem Projekt aus HTML-Dateien, deren dynamische Inhalte mit Javascript erstellt werden. Die Javascript-Funktionen senden Requests 
an das Servlet, welches wiederum mit den geforderten Daten antwortet soll. Kern der Anwendung sind die Bibliotheken von chessboardjs.com (angepasst an Cannon), welches uns das Spielbrett liefert.