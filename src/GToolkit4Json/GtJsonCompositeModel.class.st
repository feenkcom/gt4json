Class {
	#name : #GtJsonCompositeModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'models'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #'instance creation' }
GtJsonCompositeModel class >> forValue: aValue defaultValue: aDefaultValue [

	self assert: [ aValue class == self ] description: [ 
		'Value `{1}` must be of an instance of {2}.' format: { 
				aValue.
				self } ].

	^ aValue
]

{ #category : #accessing }
GtJsonCompositeModel >> createModelAt: aKey [

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
GtJsonCompositeModel >> gtJsonModelDefinitionFor: aView [

	<gtView>
	^ aView columnedTree
		  title: 'Structure';
		  priority: 60;
		  items: [ self jsonModelDefinition ];
		  children: #jsonModelDefinition;
		  column: 'Key' text: #key weight: 2;
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
GtJsonCompositeModel >> gtModelChildren [

	^ self models values
]

{ #category : #'gt - extensions' }
GtJsonCompositeModel >> gtModelsFor: aView [

	<gtView>
	^ aView columnedList
		  title: 'Models';
		  priority: 65;
		  items: [ self gtModelChildren ];
		  column: 'Value' text: #value weight: 3;
		  column: 'Type' text: #class;
		  actionUpdateButton
]

{ #category : #accessing }
GtJsonCompositeModel >> modelAt: aKey [

	^ self models
		  at: aKey
		  ifAbsent: [ self createModelAt: aKey ]
]

{ #category : #accessing }
GtJsonCompositeModel >> modelAt: aKey put: aValue [

	self models at: aKey put: aValue
]

{ #category : #accessing }
GtJsonCompositeModel >> modelDefinitionAt: aKey [

	^ self jsonModelDefinition
		  detect: [ :eachDefinition | eachDefinition key = aKey ]
		  ifNone: [ nil ]
]

{ #category : #accessing }
GtJsonCompositeModel >> models [

	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #accessing }
GtJsonCompositeModel >> valueAt: aKey [

	^ (self modelAt: aKey) value
]

{ #category : #accessing }
GtJsonCompositeModel >> valueAt: aKey put: aValue [

	| aDefinition aModel |
	aDefinition := self modelDefinitionAt: aKey.
	aDefinition
		ifNotNil: [ aModel := aDefinition createModelForValue: aValue ]
		ifNil: [ 
		aModel := GtJsonLeafModel forValue: aValue defaultValue: nil ].

	self modelAt: aKey put: aModel
]

{ #category : #testing }
GtJsonCompositeModel >> valueExists [

	"I am an instance, therefore I exist. Does not matter whether all my values are defined."

	^ true
]
