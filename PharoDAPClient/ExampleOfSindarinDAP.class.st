"
I am a class which provide an API to get some examples of DAP ready to use. 
"
Class {
	#name : 'ExampleOfSindarinDAP',
	#superclass : 'Object',
	#category : 'PharoDAPClient-Examples',
	#package : 'PharoDAPClient',
	#tag : 'Examples'
}

{ #category : 'utils' }
ExampleOfSindarinDAP >> attachArgumentsForJavaExample [
	"Returns the attach arguments for the Java client example"

	^ {
		  ('name' -> 'Attach to Java').
		  ('type' -> 'server').
		  ('hostName' -> 'localhost').
		  ('port' -> 5005).
		  ('projectName' -> 'java') } asDictionary
]

{ #category : 'utils' }
ExampleOfSindarinDAP >> attachArgumentsForPythonExample [
	"Returns the attach arguments for the Python client example"

	^ {
		  ('name' -> 'Attach to Python').
		  ('type' -> 'python').
		  ('connect' -> {
			   ('host' -> 'localhost').
			   ('port' -> 5678) } asDictionary).
		  ('redirectOutput' -> true).
		  ('showReturnValue' -> true).
		  ('justMyCode' -> false) } asDictionary
]

{ #category : 'api' }
ExampleOfSindarinDAP >> getSindarinDAPClientForJava [
	"Returns a SindarinDAPClient for Java, the client returned is an example to see how it works"

	^ DAPClientBuilder new
		  client: SindarinDAPClient new;
		  port: 64894;
		  adapterID: 'java';
		  attachArguments: self attachArgumentsForJavaExample;
		  breakpoint:
			  '/Users/flavienvolant/Documents/sindarin-dap/java/src/main/java/example/Main.java'
		  line: 9;
		  backend: DAPBackendJava new;
		  startClientSession
]

{ #category : 'api' }
ExampleOfSindarinDAP >> getSindarinDAPClientForPython [
	"Returns a SindarinDAPClient for Python, the client returned is an example to see how it works"

	^ DAPClientBuilder new
		  client: self;
		  port: 5678;
		  adapterID: 'python';
		  attachArguments: self attachArgumentsForPythonExample;
		  breakpoint:
			  '/Users/flavienvolant/Documents/sindarin-dap/py/script.py'
		  line: 10;
		  backend: DAPBackendPython new;
		  startClientSession
]
