## Object-Centric Breakpoints
This documentation describes the implementation of Object-Centric Breakpoints for any language providing an implementation of the Debugger Adapter Protocol. The Object-Centric Breakpoints API is described using [Pharo](https://pharo.org) syntax, and works on the Java, Python and Javascript examples provided in this repository. It can however be implemented in any language.

Author: Flavien Volant.

### `haltOnCreation: class`

This operation is implemented as a function breakpoint on the method that creates the object. For each target language, a language-specific mechanism (using a DAP `evaluate` request) is used to obtain the name of this method from the class passed as parameter.

Once the method name is known, the operation is reduced to creating a function breakpoint on this method with a condition that checks the type of the receiver, to ensure that the breakpoint is triggered only when an instance of the target class is created.

### `dbg haltOnCall: obj for: m`

Breaks the next time the object `obj` receives the message `m`.

As discussed in Chapter~\ref{chap\:translation}, this operation is implemented using a conditional function breakpoint on the method `m` with a condition that checks whether the current receiver is the target object.

From a design perspective, the main challenges are:

- **Condition generation.** The condition comparing the receiver with the stored object is language-specific. For each target language (Python, Java, JavaScript), a dedicated code generator produces the appropriate expression (accessing the receiver, comparing references, handling proxies or wrappers).

- **API encapsulation.** In the implementation, the DAP requests used for this operation are encapsulated in high-level methods such as `haltOnCall:for:`, which hide the low-level DAP details from the rest of the Sindarin-DAP API.

### `dbg haltOnCall: obj`

Breaks next time the object `obj` receives any message.

This operation is more complex than `dbg haltOnCall: obj for: m` because the method name is not provided by the user. Therefore, the first step is to identify the methods that can be received by the target object.

A language-specific evaluate request is used to retrieve the methods associated with the target object. For each retrieved method, Sindarin-DAP applies the `dbg haltOnCall: obj for: m` operation. The object mapping and the conditional function breakpoint creation are therefore handled by the mechanism described previously.

The following pseudo-code illustrates the sequence of operations performed by Sindarin-DAP:

```Python
methods = sindarinDAPClient evaluate("getMethods(obj)")

for each method in methods:
    sindarinDAPClient haltOnCall: obj for: method
```

### `dbg haltOnWrite: obj field: iv`

Breaks next time the instance variable `iv` of the object `obj` is written.

This operation is implemented using a DAP data breakpoint on the field `iv` of the target object.

To create a data breakpoint, Sindarin-DAP first needs to obtain the DAP variable reference corresponding to `obj`. This reference is obtained from the current suspended execution state. Then, a `dataBreakpointInfo` request is sent with this reference and the field name `iv`. This request allows the debug adapter to determine whether a data breakpoint can be created for this field and returns a `dataId` used to configure the breakpoint.

From a design perspective, the main challenges are:

- **Variable reference resolution.** To create a data breakpoint, the DAP variable reference corresponding to `obj` must first be obtained from the current suspended execution state. This requires navigating the stack frame, scopes and variables.

- **Access type configuration.** The same mechanism is used for both `haltOnWrite` and `haltOnRead`, differing only by the `accessType` parameter (``write'' vs ``read'') in the `setDataBreakpoints` request.


### `dbg haltOnWrite: obj`

Stops the execution when any field of the object `obj` is modified.

This operation extends `dbg haltOnWrite: obj field: iv` because the field name is not provided by the user. Therefore, the first step is to retrieve all fields associated with the target object.

DAP exposes object fields through its variable model. Sindarin-DAP first retrieves the DAP variable reference associated with the object in the current suspended execution state. Then, the child variables of this reference are retrieved to obtain the list of fields available on the object.

For each retrieved field, Sindarin-DAP applies the `dbg haltOnWrite: obj field: iv` operation. The creation of the data breakpoint is therefore delegated to the mechanism described previously.

The following pseudo-code illustrates the sequence of operations performed by Sindarin-DAP:

```Python
fields = sindarinDAPClient variablesForObject(
    obj,
    currentFrameId
)

for each field in fields:
    sindarinDAPClient haltOnWrite: obj field: field.name
```
