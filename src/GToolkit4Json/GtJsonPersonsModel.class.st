Class {
	#name : #GtJsonPersonsModel,
	#superclass : #GtJsonCollectionModel,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonPersonsModel >> jsonModelDefinition [
	^ GtJsonPersonModel list: self defaultValue: #()
]
