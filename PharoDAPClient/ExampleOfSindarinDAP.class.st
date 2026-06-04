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
ExampleOfSindarinDAP class >> attachArgumentsForJavaExample [
	"Returns the attach arguments for the Java client example"

	^ {
		  ('name' -> 'Attach to Java').
		  ('type' -> 'server').
		  ('hostName' -> 'localhost').
		  ('port' -> 5005).
		  ('projectName' -> 'java') } asDictionary
]

{ #category : 'utils' }
ExampleOfSindarinDAP class >> attachArgumentsForJavaScriptExample [
	"Returns the attach arguments for the JavaScript client example"

	^ {
		  ('type' -> 'pwa-node').
		  ('request' -> 'launch').
		  ('skipFiles' -> { '<node_internals>/**' }).
		  ('program'
		   ->
		   '/Users/julesboulet/Documents/VSCode_projects/Test_bugs/js/bug1.js').
		  ('stopOnEntry' -> true) } asDictionary
]

{ #category : 'utils' }
ExampleOfSindarinDAP class >> attachArgumentsForPythonExample [
	"Returns the attach arguments for the Python client example"

	^ {
		  ('program'
		   ->
		   '/Users/julesboulet/Documents/VSCode_projects/Test_bugs/py/hello_world.py').
		  ('redirectOutput' -> true).
		  ('showReturnValue' -> true).
		  ('justMyCode' -> false) } asDictionary
]

{ #category : 'api' }
ExampleOfSindarinDAP class >> getSindarinDAPClientForJava [
	"Returns a SindarinDAPClient for Java, the client returned is an example to see how it works"

	^ DAPClientBuilder newSindarinClient
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
ExampleOfSindarinDAP class >> getSindarinDAPClientForJavaScript [
	"Returns a SindarinDAPClient for JavaScript, the client returned is an example to see how it works"

	^ DAPClientBuilder newSindarinClient
		  adapterID: 'node';
		  port: 5678;
		  attachArguments: self attachArgumentsForJavaScriptExample;
		  breakpoint:
			  '/Users/julesboulet/Documents/VSCode_projects/Test_bugs/js/bug1.js'
		  line: 21;
		  backend: DAPBackendJavaScript new;
		  handleStartDebuggingRequest;
		  startClientSession
]

{ #category : 'api' }
ExampleOfSindarinDAP class >> getSindarinDAPClientForPython [
	"Returns a SindarinDAPClient for Python, the client returned is an example to see how it works"

	^ DAPClientBuilder newSindarinClient
		  port: 5678;
		  adapterID: 'python';
		  attachArguments: self attachArgumentsForPythonExample;
		  breakpoint:
			  '/Users/julesboulet/Documents/VSCode_projects/Test_bugs/py/hello_world.py'
		  line: 3;
		  backend: DAPBackendPython new;
		  startClientSession
]
