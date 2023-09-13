Class {
	#name : #GtJsonDictionaryModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'models'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'instance creation' }
GtJsonDictionaryModel class >> forValue: aValue defaultValue: aDefaultValue [

	self assert: [ aValue class == self ] description: [ 
		'Value `{1}` must be of an instance of {2}.' format: { 
				aValue.
				self } ].

	^ aValue
]

{ #category : #enumerating }
GtJsonDictionaryModel >> collect: aBlock [
	| newCollection |
	newCollection := OrderedDictionary new.
	self
		do: [ :anItemModel :aKey | 
			| aValue |
			aValue := aBlock cull: anItemModel cull: aKey.
			newCollection at: aKey put: aValue ].

	^ newCollection
]

{ #category : #accessing }
GtJsonDictionaryModel >> createModelAt: aKey [

	| aDefinition aJson aModel |
	aDefinition := self modelDefinitionAt: aKey.

	self json ifNil: [ 
		aDefinition ifNotNil: [ 
			aModel := aDefinition createDefaultModel.
			self modelAt: aKey put: aModel.
			^ aModel ] ].

	aJson := self json at: aKey.
	(aJson exists not and: [ aDefinition isNil ]) ifTrue: [ 
		^ GtJsonLeafModel new value: nil ].

	aDefinition ifNil: [ 
		aModel := GtJsonLeafModel forJson: aJson.
		self modelAt: aKey put: aModel.
		^ aModel ].

	aModel := aDefinition createModelForJson: aJson.
	self modelAt: aKey put: aModel.
	^ aModel
]

{ #category : #enumerating }
GtJsonDictionaryModel >> do: aBlock [
	^ self json
		do: [ :aValue :aKey | 
			| aModel |
			aModel := self modelAt: aKey.
			aBlock cull: aModel cull: aKey ]
]

{ #category : #accessing }
GtJsonDictionaryModel >> doesNotUnderstand: aMessage [
	(aMessage numArgs isZero
		and: [ (self modelDefinitionAt: aMessage selector) isNotNil ])
		ifTrue: [ ^ self valueAt: aMessage selector ].

	aMessage numArgs = 1
		ifTrue: [ | aSelector |
			aSelector := aMessage selector copyFrom: 1 to: aMessage selector size - 1.
			(self modelDefinitionAt: aSelector) isNotNil
				ifTrue: [ ^ self valueAt: aSelector put: aMessage arguments first ] ].

	^ super doesNotUnderstand: aMessage
]

{ #category : #'gt - extensions' }
GtJsonDictionaryModel >> gtJsonModelDefinitionFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Model structure';
		  priority: 60;
		  items: [ self jsonModelDefinition ];
		  children: [ :anItem | anItem jsonModelDefinition asCollection ];
		  column: 'Key' text: #key weight: 1.2;
		  column: 'Value' text: [ :aDefinition | 
			  aDefinition valueDo: [ :aValue :isDefault | 
					  isDefault
						  ifFalse: [ aValue ]
						  ifTrue: [ 
							  aValue asRopedText foreground:
									  BrGlamorousColors disabledButtonTextColor ] ] ];
		  column: 'Type' text: #modelClass weight: 0.5;
		  send: [ :aDefinition | aDefinition valueDo: [ :aValue | aValue ] ];
		  actionUpdateButton
]

{ #category : #'gt - extensions' }
GtJsonDictionaryModel >> gtModelChildren [

	^ self models associations
]

{ #category : #'gt - extensions' }
GtJsonDictionaryModel >> gtModelsFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Model cache';
		  tooltip: 'I display model objects that were already instantiated';
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
GtJsonDictionaryModel >> json: anObject [
	super json: anObject.
	models := nil
]

{ #category : #accessing }
GtJsonDictionaryModel >> modelAt: aKey [

	^ self models
		  at: aKey
		  ifAbsent: [ self createModelAt: aKey ]
]

{ #category : #accessing }
GtJsonDictionaryModel >> modelAt: aKey put: aValue [

	self models at: aKey put: aValue
]

{ #category : #accessing }
GtJsonDictionaryModel >> modelDefinitionAt: aKey [

	^ self jsonModelDefinition
		  detect: [ :eachDefinition | eachDefinition includesKey: aKey ]
		  ifNone: [ nil ]
]

{ #category : #accessing }
GtJsonDictionaryModel >> models [

	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #accessing }
GtJsonDictionaryModel >> size [
	self json ifNotNil: [ :aJson | ^ aJson jsonObject size ].
	^ models ifNotNil: #size ifNil: [ 0 ]
]

{ #category : #accessing }
GtJsonDictionaryModel >> valueAt: aKey [

	^ (self modelAt: aKey) value
]

{ #category : #accessing }
GtJsonDictionaryModel >> valueAt: aKey put: aValue [
	| aDefinition aModel |
	aDefinition := self modelDefinitionAt: aKey.
	aDefinition
		ifNotNil: [ aModel := aDefinition createModelForValue: aValue ]
		ifNil: [ aModel := GtJsonLeafModel forValue: aValue defaultValue: nil ].

	self modelAt: aKey put: aModel
]

{ #category : #testing }
GtJsonDictionaryModel >> valueExists [

	"I am an instance, therefore I exist. Does not matter whether all my values are defined."

	^ true
]

{ #category : #enumerating }
GtJsonDictionaryModel >> withIndexCollect: aBlock [
	^ self collect: aBlock
]
