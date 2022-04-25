Class {
	#name : #GtJsonDateModel,
	#superclass : #GtJsonLeafModel,
	#category : #'GToolkit4Json-Model'
}

{ #category : #accessing }
GtJsonDateModel >> convertJsonObjectToValue [

	^ self json jsonObject asDate
]
