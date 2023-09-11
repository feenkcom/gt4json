Class {
	#name : #GtJsonCollectionModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'models'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #accessing }
GtJsonCollectionModel >> asBrItemsProvider [
	^ BrSequenceableCollectionItemsProvider
		forCollection: (self collect: #yourself)
]

{ #category : #enumerating }
GtJsonCollectionModel >> collect: aBlock [
	^ Array
		new: self size
		streamContents: [ :aStream | 
			self
				do: [ :anItemModel :anIndex | 
					| aValue |
					aValue := aBlock cull: anItemModel cull: anIndex.
					aStream nextPut: aValue ] ]
]

{ #category : #accessing }
GtJsonCollectionModel >> createModelAt: anIndex [

	| aDefinition aJson aModel |
	aDefinition := self jsonModelDefinition.

	self json ifNil: [ 
		| aValue |
		aValue := aDefinition ifNotNil: #defaultValue.
		^ GtJsonLeafModel new value: aValue ].

	aJson := self json at: anIndex.
	(aJson exists not and: [ aDefinition isNil ]) ifTrue: [ 
		^ GtJsonLeafModel new value: nil ].

	aDefinition ifNil: [ 
		aModel := GtJsonLeafModel forJson: aJson.
		self modelAt: anIndex put: aModel.
		^ aModel ].

	aModel := aDefinition createModelForJson: aJson.
	self modelAt: anIndex put: aModel.
	^ aModel
]

{ #category : #enumerating }
GtJsonCollectionModel >> detect: aBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Answer the first element for which aBlock evaluates to true."

	^ self detect: aBlock ifNone: [ self errorNotFound: aBlock ]
]

{ #category : #enumerating }
GtJsonCollectionModel >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	If some element evaluates aBlock to true, then cull this element into 
	foundBlock and answer the result of this evaluation. 
	If none evaluate to true, then evaluate exceptionBlock."

	self do: [ :each | (aBlock value: each) ifTrue: [ ^ foundBlock cull: each ] ].
	^ exceptionBlock value
]

{ #category : #enumerating }
GtJsonCollectionModel >> detect: aBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Answer the first element for which aBlock evaluates to true. If none  
	evaluate to true, then evaluate the argument, exceptionBlock."

	^ self
		detect: aBlock
		ifFound: [ :element | element ]
		ifNone: exceptionBlock
]

{ #category : #enumerating }
GtJsonCollectionModel >> do: aBlock [
	^ 1
		to: self size
		do: [ :anIndex | 
			| aModel |
			aModel := self modelAt: anIndex.
			aBlock cull: aModel cull: anIndex ]
]

{ #category : #enumerating }
GtJsonCollectionModel >> do: aBlock separatedBy: aSeparatorBlock [
	| isBeforeFirst |
	isBeforeFirst := true.
	^ 1
		to: self size
		do: [ :anIndex | 
			| aModel |
			isBeforeFirst 
				ifTrue: [ isBeforeFirst := false ]
				ifFalse: [ aSeparatorBlock value ].
			aModel := self modelAt: anIndex.
			aBlock cull: aModel cull: anIndex ]
]

{ #category : #private }
GtJsonCollectionModel >> errorNotFound: anObject [
	NotFound signalFor: anObject
]

{ #category : #enumerating }
GtJsonCollectionModel >> flatCollect: aBlock [
	^ Array
		new: self size
		streamContents: [ :aStream | 
			self
				do: [ :anItemModel :anIndex | 
					| aValue |
					aValue := aBlock cull: anItemModel cull: anIndex.
					aStream nextPutAll: aValue ] ]
]

{ #category : #'gt - extensions' }
GtJsonCollectionModel >> gtJsonModelDefinitionFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Structure';
		  priority: 60;
		  items: [ self jsonModelDefinition  asCollection ];
		  children: [ :anItem | anItem jsonModelDefinition asCollection ];
		  expandUpTo: 1;
		  column: 'Key' text: #key weight: 1.5;
		  column: 'Value' text: [ :aDefinition | 
			  aDefinition valueDo: [ :aValue :isDefault | 
					  isDefault
						  ifFalse: [ aValue ]
						  ifTrue: [ 
							  aValue asRopedText foreground:
									  BrGlamorousColors disabledButtonTextColor ] ] ];
		  column: 'Type' text: #modelClass;
		  send: [ :aDefinition | aDefinition valueDo: [ :aValue | aValue ] ];
		  actionUpdateButton
]

{ #category : #'gt - extensions' }
GtJsonCollectionModel >> gtModelChildren [

	^ self models associations
]

{ #category : #'gt - extensions' }
GtJsonCollectionModel >> gtModelsFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Models';
		  priority: 65;
		  items: [ self gtModelChildren ];
		  column: 'Key' text: #key;
		  column: 'Value' text: [ :anAssoc | anAssoc value value ] weight: 3;
		  send: #value;
		  actionUpdateButton;
		  actionButtonIcon: BrGlamorousIcons trash
		  tooltip: 'Remove models'
		  action: [ :aButton :aTab | 
			  models := nil.
			  aTab viewContentElement phlow update ]
]

{ #category : #accessing }
GtJsonCollectionModel >> items: aCollection [
	aCollection
		withIndexDo: [ :aModel :anIndex | self models at: anIndex put: aModel ]
]

{ #category : #accessing }
GtJsonCollectionModel >> jsonModelDefinition [
	"Collection can have only one definition. 
	We therefore return the definition instead of a collection 
	as it is common in the dictionary model."
	^ GtJsonLeafModel list: self defaultValue: #()
]

{ #category : #accessing }
GtJsonCollectionModel >> modelAt: aKey [

	^ self models
		  at: aKey
		  ifAbsent: [ self createModelAt: aKey ]
]

{ #category : #accessing }
GtJsonCollectionModel >> modelAt: aKey put: aValue [
	self models at: aKey put: aValue
]

{ #category : #accessing }
GtJsonCollectionModel >> models [
	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #printing }
GtJsonCollectionModel >> printOn: aStream [
	super printOn: aStream.

	aStream
		space;
		nextPut: $[;
		print: self size;
		nextPutAll: (' item' asPluralBasedOn: self size);
		nextPut: $]
]

{ #category : #enumerating }
GtJsonCollectionModel >> select: aBlock [
	| someModels |
	someModels := Array
			new: self size
			streamContents: [ :aStream | 
				self
					do: [ :anItemModel :anIndex | 
						| aValue |
						aValue := aBlock cull: anItemModel cull: anIndex.
						aValue ifTrue: [ aStream nextPut: anItemModel ] ] ].

	^ self class new items: someModels
]

{ #category : #accessing }
GtJsonCollectionModel >> size [
	self json ifNotNil: [ :aJson | ^ aJson jsonObject size ].
	^ models ifNotNil: #size ifNil: [ 0 ]
]

{ #category : #enumerating }
GtJsonCollectionModel >> withIndexCollect: aBlock [
	^ self collect: aBlock
]
