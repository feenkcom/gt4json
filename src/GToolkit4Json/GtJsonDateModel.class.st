Class {
	#name : #GtJsonDateModel,
	#superclass : #GtJsonLeafModel,
	#category : #'GToolkit4Json-Model'
}

{ #category : #accessing }
GtJsonDateModel >> convertJsonObjectToValue [

	^ Date readFrom: self json jsonObject pattern: 'yyyy-mm-dd' 
]
