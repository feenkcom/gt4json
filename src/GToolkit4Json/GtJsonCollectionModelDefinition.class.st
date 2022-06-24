Class {
	#name : #GtJsonCollectionModelDefinition,
	#superclass : #Object,
	#instVars : [
		'object',
		'defaultValue',
		'modelClass'
	],
	#category : #'GToolkit4Json-Model - Definition'
}

{ #category : #'instace creation' }
GtJsonCollectionModelDefinition >> createModelForJson: aJsonChild [
	"Return a model object of a collection item."

	<return: #GtJsonModel>
	^ self modelClass forJson: aJsonChild defaultValue: self defaultValue
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> defaultValue [

	^ defaultValue
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> defaultValue: anObject [

	defaultValue := anObject
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> jsonModelDefinition [
	^ self object
		withIndexCollect: [ :aModel :anIndex | 
			GtJsonCollectionItemModelDefinition new
				object: aModel;
				modelClass: self modelClass;
				key: anIndex ]
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> key [
	^ ''
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> modelClass [

	^ modelClass
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> modelClass: anObject [

	modelClass := anObject
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> object [

	^ object
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> object: anObject [

	object := anObject
]

{ #category : #accessing }
GtJsonCollectionModelDefinition >> valueDo: aBlock [
	^ aBlock cull: self object cull: false
]
