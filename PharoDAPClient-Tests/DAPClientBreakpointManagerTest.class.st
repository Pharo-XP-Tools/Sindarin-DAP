Class {
	#name : 'DAPClientBreakpointManagerTest',
	#superclass : 'TestCase',
	#instVars : [
		'bpManger',
		'evaluatorTrue',
		'evaluatorFalse',
		'supportsFunctionBreakpointsTrue',
		'supportsFunctionBreakpointsFalse'
	],
	#category : 'PharoDAPClient-Tests',
	#package : 'PharoDAPClient-Tests'
}

{ #category : 'running' }
DAPClientBreakpointManagerTest >> setUp [

	super setUp.

	bpManger := DAPClientBreakpointManager new.

	evaluatorTrue := Mock new.
	(evaluatorTrue stub evaluateBoolean: Any frameId: Any) willReturn: true.

	evaluatorFalse := Mock new.
	(evaluatorFalse stub evaluateBoolean: Any frameId: Any) willReturn: false.
	
	supportsFunctionBreakpointsTrue := Mock new.
	(supportsFunctionBreakpointsTrue stub adapterSupport: Any) willReturn: true.

	supportsFunctionBreakpointsFalse := Mock new.
	(supportsFunctionBreakpointsFalse stub adapterSupport: Any) willReturn: false
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testGiveContinueStrategyFor [

	self
		assert:
			(bpManger giveContinueStrategyFor: supportsFunctionBreakpointsTrue)
				class
		equals: DebugContinueStrategy.

	self
		assert:
			(bpManger giveContinueStrategyFor: supportsFunctionBreakpointsFalse)
				class
		equals: StepUntilStrategy.

	"When breakpoint manager own an InvokeBreakpoint it should return StepUntilStrategy every time"
	bpManger addInvokeBreakpoint: DAPInvokeBreakpoint new.

	self
		assert:
			(bpManger giveContinueStrategyFor: supportsFunctionBreakpointsTrue)
				class
		equals: StepUntilStrategy.

	self
		assert:
			(bpManger giveContinueStrategyFor: supportsFunctionBreakpointsFalse)
				class
		equals: StepUntilStrategy
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForFromDebugJAVA [

	| frame |
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'setStr').

	frame := {
		         ('source' -> {
			          ('name' -> 'Bar.java').
			          ('path' -> 'path/to/java/file.java').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 23).
		         ('column' -> 1).
		         ('name' -> 'Bar.setStr(String)').
		         ('id' -> 1) } asDictionary.

	self assert: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForFromDebugJS [

	| frame |
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'toto').

	frame := {
		         ('source' -> {
			          ('name' -> 'path/to/js/file.js').
			          ('path' -> 'path/to/js/file.js').
			          ('sourceReference' -> 0) } asDictionary).
		         ('presentationHint' -> 'normal').
		         ('line' -> 7).
		         ('column' -> 9).
		         ('name'
		          ->
		          'Bar.toto [/Users/flavienvolant/Documents/sindarin-dap/js/script.js]').
		         ('id' -> 61) } asDictionary.

	self assert: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForFromDebugPY [

	| frame |
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'setStr').

	frame := {
		         ('source' -> {
			          ('path' -> 'path/to/python/file.py').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 3).
		         ('column' -> 1).
		         ('name' -> 'bar.setStr').
		         ('id' -> 4) } asDictionary.

	self assert: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForShouldBreakWhenAtLeastOneFunctionBreakpointMatches [

	| frame |
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'toto').
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'thisIsNottoto').

	frame := {
		         ('source' -> {
			          ('path' -> 'path/to/python/file.py').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 3).
		         ('column' -> 1).
		         ('name' -> 'bar.thisIsNottoto').
		         ('id' -> 4) } asDictionary.

	self assert: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForShouldBreakWhenFunctionbreakpointConditionIsTrue [

	| frame |
	bpManger addFunctionBreakpoint: (DAPFunctionBreakpoint new
			 name: 'toto';
			 condition: 'true').

	frame := {
		         ('source' -> {
			          ('path' -> 'path/to/python/file.py').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 3).
		         ('column' -> 1).
		         ('name' -> 'bar.toto').
		         ('id' -> 4) } asDictionary.

	self assert: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForShouldNotBreakWhenFunctionNameDoesNotMatchBreakpoint [

	| frame |
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'toto').
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'tata').

	frame := {
		         ('source' -> {
			          ('path' -> 'path/to/python/file.py').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 3).
		         ('column' -> 1).
		         ('name' -> 'bar.setStr').
		         ('id' -> 4) } asDictionary.

	self deny: (bpManger isFunctionBreakpointTriggeredFor: frame evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForShouldNotBreakWhenFunctionbreakpointConditionIsFalse [

	| frame |
	bpManger := DAPClientBreakpointManager new.
	bpManger addFunctionBreakpoint: (DAPFunctionBreakpoint new
			 name: 'toto';
			 condition: 'false').

	frame := {
		         ('source' -> {
			          ('path' -> 'path/to/python/file.py').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 3).
		         ('column' -> 1).
		         ('name' -> 'bar.toto').
		         ('id' -> 4) } asDictionary.

	self deny: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorFalse)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsFunctionBreakpointTriggeredForShouldNotMatchPartialFunctionNameToBreakpoint [

	| frame |
	bpManger addFunctionBreakpoint:
		(DAPFunctionBreakpoint new name: 'toto').

	frame := {
		         ('source' -> {
			          ('path' -> 'path/to/python/file.py').
			          ('sourceReference' -> 0) } asDictionary).
		         ('line' -> 3).
		         ('column' -> 1).
		         ('name' -> 'bar.thisIsNottoto').
		         ('id' -> 4) } asDictionary.

	self deny: (bpManger
			 isFunctionBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]

{ #category : 'tests' }
DAPClientBreakpointManagerTest >> testIsInvokeBreakpointTriggeredFor [
	"Invoke Breakpoints are only checking the sender, therefore the logic is in evaluator and how to create this condition"

	| frame |
	frame := { ('id' -> 1) } asDictionary.

	self deny: (bpManger
			 isInvokeBreakpointTriggeredFor: frame
			 evaluator: evaluatorFalse).

	self deny: (bpManger
			 isInvokeBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue).

	bpManger addInvokeBreakpoint: (DAPInvokeBreakpoint new condition: '').

	self deny: (bpManger
			 isInvokeBreakpointTriggeredFor: frame
			 evaluator: evaluatorFalse).

	self assert: (bpManger
			 isInvokeBreakpointTriggeredFor: frame
			 evaluator: evaluatorTrue)
]
