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

{ #category : #accessing }
GtJsonDictionaryModel >> createModelAt: aKey [

	| aDefinition aJson aModel |
	aDefinition := self modelDefinitionAt: aKey.

	self json ifNil: [ 
		| aValue |
		aValue := aDefinition ifNotNil: #defaultValue.
		^ GtJsonLeafModel new value: aValue ].

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

{ #category : #'gt - extensions' }
GtJsonDictionaryModel >> gtJsonModelDefinitionFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Model Structure';
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
		  title: 'Model Cache';
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
		  detect: [ :eachDefinition | eachDefinition key = aKey ]
		  ifNone: [ nil ]
]

{ #category : #accessing }
GtJsonDictionaryModel >> models [

	^ models ifNil: [ models := Dictionary new ]
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
		ifNil: [ 
		aModel := GtJsonLeafModel forValue: aValue defaultValue: nil ].

	self modelAt: aKey put: aModel
]

{ #category : #testing }
GtJsonDictionaryModel >> valueExists [

	"I am an instance, therefore I exist. Does not matter whether all my values are defined."

	^ true
]
