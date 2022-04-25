Class {
	#name : #GtJsonDateAndTimeModel,
	#superclass : #GtJsonLeafModel,
	#category : #'GToolkit4Json-Model'
}

{ #category : #private }
GtJsonDateAndTimeModel >> convertJsonObjectToValue [

	^ self json jsonObject asDateAndTime
]
