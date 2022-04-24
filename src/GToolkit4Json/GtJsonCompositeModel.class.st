Class {
	#name : #GtJsonCompositeModel,
	#superclass : #GtJsonModel,
	#instVars : [
		'models'
	],
	#category : #'GToolkit4Json-Model'
}

{ #category : #accessing }
GtJsonCompositeModel >> createModelAt: aKey [

	| aDefinition aJson aModel |
	aDefinition := self jsonModelDefinition
		               detect: [ :eachDefinition | 
		               eachDefinition key = aKey ]
		               ifNone: [ nil ].

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

{ #category : #accessing }
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
GtJsonCompositeModel >> models [

	^ models ifNil: [ models := Dictionary new ]
]

{ #category : #accessing }
GtJsonCompositeModel >> valueAt: aKey [

	^ (self modelAt: aKey) value
]

{ #category : #accessing }
GtJsonCompositeModel >> valueAt: aKey put: aValue [

	self modelAt: aKey put: aValue
]
