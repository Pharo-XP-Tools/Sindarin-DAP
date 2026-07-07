"
I am a breakpoint manager used by DAPClient to add breakpoint during a debugging session.

Indeed, natively adapters do not provide a way to just add a breakpoint: you have to set every breakpoint including breakpoints already set. 
So this object allow us to have an easier api for breakpoint addition.
"
Class {
	#name : 'DAPClientBreakpointManager',
	#superclass : 'Object',
	#instVars : [
		'breakpoints',
		'functionBreakpoints',
		'dataBreakpoints',
		'invokeBreakpoints'
	],
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'adding' }
DAPClientBreakpointManager >> addBreakpoint: aDAPBreakpoint [

	breakpoints add: aDAPBreakpoint
]

{ #category : 'adding' }
DAPClientBreakpointManager >> addDataBreakpoint: aDAPDataBreakpoint [

	dataBreakpoints add: aDAPDataBreakpoint
]

{ #category : 'adding' }
DAPClientBreakpointManager >> addFunctionBreakpoint: aDAPFunctionBreakpoint [

	functionBreakpoints add: aDAPFunctionBreakpoint
]

{ #category : 'adding' }
DAPClientBreakpointManager >> addInvokeBreakpoint: anInvokeBreakpoint [

	invokeBreakpoints add: anInvokeBreakpoint
]

{ #category : 'helpers' }
DAPClientBreakpointManager >> extractFunctionName: aString [

	^ (aString findTokens: '.') last
]

{ #category : 'accessing' }
DAPClientBreakpointManager >> giveContinueStrategyFor: aDAPClient [
	"Answer a continue strategy for a specific dap client"

	(aDAPClient adapterSupport: 'supportsFunctionBreakpoints') ifFalse: [
		^ StepUntilStrategy new ].

	invokeBreakpoints ifNotEmpty: [ ^ StepUntilStrategy new ].


	^ DebugContinueStrategy new
]

{ #category : 'initialization' }
DAPClientBreakpointManager >> initialize [

	super initialize.
	breakpoints := OrderedCollection new.
	functionBreakpoints := OrderedCollection new.
	dataBreakpoints := OrderedCollection new.
	invokeBreakpoints := OrderedCollection new
]

{ #category : 'asserting' }
DAPClientBreakpointManager >> isFunctionBreakpointTriggeredFor: aDAPStackFrame evaluator: clientDAP [
	"Answer whether aDAPStackFrame should halt due to a function breakpoint. Breakpoint conditions are evaluated in the context of the receiver frame by the clientDAP."

	| functionName |
	functionName := self extractFunctionName:
		                (self normalizeFrameName:
			                 (aDAPStackFrame at: 'name')).
	^ functionBreakpoints anySatisfy: [ :functionBreakpoint |
			  functionBreakpoint name = functionName and: [
					  clientDAP
						  evaluateBoolean: functionBreakpoint condition
						  frameId: (aDAPStackFrame at: 'id') ] ]
]

{ #category : 'asserting' }
DAPClientBreakpointManager >> isInvokeBreakpointTriggeredFor: aDAPStackFrame evaluator: clientDAP [
	"Answer whether aDAPStackFrame should halt due to an invoke breakpoint. Breakpoint conditions are evaluated in the context of the sender frame by the clientDAP."

	^ invokeBreakpoints anySatisfy: [ :invokeBreakpoint |
			  clientDAP
				  evaluateBoolean: invokeBreakpoint condition
				  frameId: (aDAPStackFrame at: 'id') ]
]

{ #category : 'asserting' }
DAPClientBreakpointManager >> isTriggeredFor: aDAPStackFrames evaluator: clientDAP [
	"Answer whether any function or invoke breakpoint is triggered for aDAPStackFrames."

	^ [
		  (self
			   isFunctionBreakpointTriggeredFor: aDAPStackFrames first
			   evaluator: clientDAP) or: [
				  self
					  isInvokeBreakpointTriggeredFor: aDAPStackFrames second
					  evaluator: clientDAP ] ]
		  on: Error
		  do: [ ^ false ]
]

{ #category : 'helpers' }
DAPClientBreakpointManager >> normalizeFrameName: aString [

	| cleaned index |
	cleaned := aString.

	"remove JS file suffix [file]"
	index := cleaned indexOf: $[.
	index > 0 ifTrue: [ cleaned := cleaned copyFrom: 1 to: index - 1 ].

	cleaned := cleaned trimmed.

	"remove Java params (type)"
	index := cleaned indexOf: $(.
	index > 0 ifTrue: [ cleaned := cleaned copyFrom: 1 to: index - 1 ].

	^ cleaned trimmed
]

{ #category : 'adding' }
DAPClientBreakpointManager >> setBreakPointsFor: aDAPClient [

	self flag: 'todo'
]

{ #category : 'adding' }
DAPClientBreakpointManager >> setDataBreakPointsFor: aDAPClient [

	aDAPClient setDataBreakPoints:
		(DAPSetDataBreakpointsArguments new breakpoints:
			 dataBreakpoints asArray)
]

{ #category : 'adding' }
DAPClientBreakpointManager >> setFunctionBreakPointsFor: aDAPClient [

	aDAPClient setFunctionBreakpoints:
		(DAPSetFunctionBreakpointsArguments new breakpoints:
			 functionBreakpoints asArray)
]
