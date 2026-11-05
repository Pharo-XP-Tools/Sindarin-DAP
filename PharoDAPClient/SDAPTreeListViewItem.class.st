"
A tree list view item for displaying Sindarin DAP call stacks.
"
Class {
	#name : 'SDAPTreeListViewItem',
	#superclass : 'Object',
	#instVars : [
		'name',
		'children',
		'icon',
		'data'
	],
	#category : 'PharoDAPClient-Presenters',
	#package : 'PharoDAPClient',
	#tag : 'Presenters'
}

{ #category : 'accessing' }
SDAPTreeListViewItem >> children [

	^ children ifNil:[children := OrderedCollection new]
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> children: anObject [

	children := anObject
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> data [

	^ data
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> data: anObject [

	data := anObject
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> icon [

	^ icon
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> icon: anObject [

	icon := anObject
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> name [

	^ name
]

{ #category : 'accessing' }
SDAPTreeListViewItem >> name: anObject [

	name := anObject
]
