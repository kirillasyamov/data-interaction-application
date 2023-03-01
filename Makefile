all: clean build run 
clean:
	mvn clean
build: 
	mvn package
run:
	java -jar target\console-app-alpha.jar