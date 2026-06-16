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

{ #category : 'utilities' }
ExampleOfSindarinDAP class >> argumentsForJavaExample [
	"Returns the launch arguments for the Java client example"

	^ {
		  ('mainClass' -> 'example.Main').
		  ('classPaths'
		   ->
		   { '/path/to/compile/classes' }).
		  ('console' -> 'internalConsole') } asDictionary
]

{ #category : 'utilities' }
ExampleOfSindarinDAP class >> argumentsForJavaScriptExample [
	"Returns the attach arguments for the JavaScript client example"

	^ {
		  ('type' -> 'pwa-node').
		  ('request' -> 'launch').
		  ('skipFiles' -> { '<node_internals>/**' }).
		  ('program' -> (FileLocator imageDirectory
		    /
		    'pharo-local/iceberg/Pharo-XP-Tools/Sindarin-DAP/scriptExamples/JSScript.js')
			   fullName).
		  ('stopOnEntry' -> true) } asDictionary
]

{ #category : 'utilities' }
ExampleOfSindarinDAP class >> argumentsForPythonExample [
	"Returns the attach arguments for the Python client example"

	^ {
		  ('program' -> (FileLocator imageDirectory
		    /
		    'pharo-local/iceberg/Pharo-XP-Tools/Sindarin-DAP/scriptExamples/pythonScript.py')
			   fullName).
		  ('redirectOutput' -> true).
		  ('showReturnValue' -> true).
		  ('justMyCode' -> false) } asDictionary
]

{ #category : 'api' }
ExampleOfSindarinDAP class >> getSindarinDAPClientForJava [
	"Returns a SindarinDAPClient for Java, the client returned is an example to see how it works"

	^ DAPClientBuilder newSindarinClient
		  port: 5678;
		  adapterID: 'java';
		  arguments: self argumentsForJavaExample;
		  breakpoint: (FileLocator imageDirectory
			   /
				   '/Users/flavienvolant/Documents/sindarin-dap/java/src/main/java/example/Main.java')
				  fullName
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
		  arguments: self argumentsForJavaScriptExample;
		  breakpoint: (FileLocator imageDirectory
			   /
				   'pharo-local/iceberg/Pharo-XP-Tools/Sindarin-DAP/scriptExamples/JSScript.js')
				  fullName
		  line: 21;
		  backend: DAPBackendJavaScript new;
		  startDebuggingRequest: true;
		  startClientSession
]

{ #category : 'api' }
ExampleOfSindarinDAP class >> getSindarinDAPClientForPython [
	"Returns a SindarinDAPClient for Python, the client returned is an example to see how it works"

	^ DAPClientBuilder newSindarinClient
		  port: 5678;
		  adapterID: 'python';
		  arguments: self argumentsForPythonExample;
		  breakpoint: (FileLocator imageDirectory
			   /
				   'pharo-local/iceberg/Pharo-XP-Tools/Sindarin-DAP/scriptExamples/pythonScript.py')
				  fullName
		  line: 6;
		  backend: DAPBackendPython new;
		  startClientSession
]
