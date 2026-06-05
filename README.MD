# Sindarin-DAP

`Sindarin-DAP` is an implementation of a Debug Adapter Protocol (DAP) client. It relies on the structures and types provided by [Pharo-LanguageServer](https://github.com/Pharo-XP-Tools/Pharo-LanguageServer/tree/DAP-Tools).

The goal of this project is to map Sindarin commands with their DAP equivalents, allowing the debugger to be controlled through Sindarin scripts.

The client currently works exclusively over socket connections.

## Installation

``` smalltalk
Metacello new
	baseline: 'PharoDAPClient';
	repository: 'github://FlavienVolant/sindarin-dap:main';
	load
```

## Usage

To start working with DAP and adapters, you will need a DAPClient object and connect it to the provided User Interface `ClientDAPPresenter`. 

You must use the builder `DAPClientBuilder` in order to build clients. 

### Build a DAP client

A basic DAP Client only provides functionalities from the DAP protocol. To build a DAP Client, you can use the builder with this type of arguments:

```smalltalk

myDAPClient := DAPClientBuilder new
        host: aHost;
        port: aPort;
        adapterID: 'myAdapterId';
        attachArguments: aDictionaryOfAttachArguments;
        breakpoint: aFilePath;
        line: aLineNumber;
        backend: DAPBackendMyLanguage new;
		startDebuggingRequest: aBoolean;
        startClientSession

``` 

Where: 
- `aHost` and `aPort` are the host and port of the adapter (where it is deployed);
- `'myAdapterId'` is the id of the adapter; 
- `aDictionaryOfAttachArguments` is a dictionary with attach arguments
- `aFilePath` is the path of the file where you want to place the first breakpoint and `aLineNumber` corresponding the line number
- `DAPBackendMyLanguage` is an object providing utils methods to make DAP request according to the language in which your project is coded.
- `aBoolean` is `false` by default but must be `true` is the adapter on which you will connect sends a `startDebuggingRequest` (ex: "js-debug" adapter)  

### Build a Sindarin DAP Client

A Sindarin DAP Client provides functionalities from the DAP protocol and other functionalities (inspired by the Sindarin project) such as: get all calls to a method, get all instantiations of a class, ... 
To build a Sindarin DAP Client, you can use the builder this way:

```smalltalk

myDAPClient := DAPClientBuilder newSindarinClient
        host: aHost;
        port: aPort;
        adapterID: 'myAdapterId';
        attachArguments: aDictionaryOfAttachArguments;
        breakpoint: aFilePath;
        line: aLineNumber;
        backend: DAPBackendMyLanguage new;
        startClientSession

``` 

Where: 
- `aHost` and `aPort` are the host and port of the adapter (where it is deployed);
- `'myAdapterId'` is the id of the adapter; 
- `aDictionaryOfAttachArguments` is a dictionary with attach arguments
- `aFilePath` is the path of the file where you want to place the first breakpoint and `aLineNumber` corresponding the line number
- `DAPBackendMyLanguage` is an object providing utils methods to make DAP request according to the language in which your project is coded.

You can find some examples of Sindarin DAP Clients in `ExampleOfSindarinDAP`. 

### Backend

Currently, there are some backends provided (child classes of `DAPBackend`):

- Python -> `DAPBackendPython`
- Java -> `DAPBackendJava`
- JavaScript -> `DAPBackendJavaScript`

### Launch the User Interface (UI)

Once you have built a DAP Client, you can launch the UI by doing:

```smalltalk

client := ClientDAPPresenter newWithClient: myDAPClient.
client open.

```

Where `myDAPClient` is a DAP Client already built. 

Then the UI gives access to a lot of debugger functionalities such as: stepIn, stepOut, continue, set breakpoints, ...

## Adapters configuration 

Here, we describe how to setup some adapters to link with your DAP Client. 

Note that the list provided here is not exhaustive and you can use your favorite adapter as long as it support DAP protocol. 

### Python

For python, we suggest to use [`debugpy`](https://github.com/microsoft/debugpy) as adapter.

#### Installation

Install `debugpy` using pip:

```bash
pip install debugpy
```

#### Starting the DAP Adapter

Run your Python script with `debugpy` and wait for the client to attach:

```bash
python -m debugpy --listen 5678 --wait-for-client myPythonScript.py
```

You can choose an other port than 5678 but it is the common one for debugpy.


### Java

The Java client relies on the [java-debug](https://github.com/microsoft/java-debug) adapter from Microsoft.  
This adapter is designed to work as a plugin for the Java Language Server ([eclipse.jdt.ls](https://github.com/eclipse-jdtls/eclipse.jdt.ls)).


#### Requirements

- `eclipse.jdt.ls` (Java Language Server)
- `java-debug` plugin


#### Getting the Java Debug Adapter

One simple way to obtain the adapter is to install the VS Code extension:

- **Debugger for Java (Microsoft)**

After installation, you can find the required JAR in:
```
.vscode/extensions/vscjava.vscode-java-debug-<version>/server/
```

Look for a file like:
```
com.microsoft.java.debug.plugin-<version>.jar
```

#### Preparing the Target JVM

The Java program must be started in debug mode using **JDWP**, so the debugger can attach to it:

```bash
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5005 \
  -cp target/classes \
  example.Main
```
This starts the JVM in debug mode and listens on port 5005.

#### Starting the LSP Server with java-debug

To use `java-debug`, you must start `eclipse.jdt.ls` with the debug plugin included in the `bundles` initialization option:

```json
{
  "initializationOptions": {
    "bundles": [
      "path/to/com.microsoft.java.debug.plugin-<version>.jar"
    ]
  }
}
```

#### Starting a Debug Session
Once eclipse.jdt.ls is running, send the following command via your LSP client:
``` json
{
  "command": "vscode.java.startDebugSession"
}
```
The server will respond with a port number where the DAP adapter is listening.


### JavaScript (Node.js)

This client uses the Microsoft **vscode-js-debug** adapter.

#### Requirements

- Node.js
- [`vscode-js-debug`](https://github.com/microsoft/vscode-js-debug) (tested with `v1.112.0`)

#### Getting the JavaScript Debug Adapter

Download a release from:

https://github.com/microsoft/vscode-js-debug/releases

Extract it, then locate the DAP server entry point:
```
js-debug/src/dapDebugServer.js
```

#### Starting the Adapter

Launch the debug adapter server:
```
node js-debug/src/dapDebugServer.js 5678
```
The adapter will listen for DAP connections on port `5678`.

## Examples

### Python client example

You can run an example of Sindarin DAP Client by:

- Starting the `debubpy` adapter with `python3 debugpy-adapter --port 5678`
- In a Pharo Playground, run:
``` smalltalk
client := ClientDAPPresenter newWithClient: ExampleOfSindarinDAP getSindarinDAPClientForPython.
client open.
```

### Java client example

You can run an example of Sindarin DAP Client by:

- Starting your Java program with JDWP enabled
- Starting `eclipse.jdt.ls` with the `java-debug` plugin
- Sending the `vscode.java.startDebugSession` command via your LSP client
- Retrieving the port from the response
- In a Pharo Playground, run:
``` smalltalk
client := ClientDAPPresenter newWithClient: ExampleOfSindarinDAP getSindarinDAPClientForJava.
client open.
```

### JavaScript client example

You can run an example of Sindarin DAP Client by:

- Starting the js-debug adapter in its directory:
```bash
node js-debug/src/dapDebugServer.js 5678
```

- In a Pharo Playground, run:
```smalltalk
client := ClientDAPPresenter newWithClient: ExampleOfSindarinDAP getSindarinDAPClientForJavaScript.
client open.
```

Then you will have access to the UI and you can play with it to discover how it works.
