"
I am a strategy to do a ""Continue"" action by doing lots of ""StepIn"" until a breakpoint or functionBreakpoint happens.
"
Class {
	#name : 'StepUntilStrategy',
	#superclass : 'AbstractContinueStrategy',
	#category : 'PharoDAPClient-Model',
	#package : 'PharoDAPClient',
	#tag : 'Model'
}

{ #category : 'requests' }
StepUntilStrategy >> continue: sindarinDAPClient [
	"work in progress for function and invoke bp only"

	sindarinDAPClient stepUntil: [
			sindarinDAPClient hasEnteredNewCall and: [
					sindarinDAPClient breakpointManager
						isTriggeredFor:
						(sindarinDAPClient stackFrames: sindarinDAPClient mainThreadId)
						evaluator: sindarinDAPClient ] ]
]
