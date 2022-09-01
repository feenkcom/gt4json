Class {
	#name : #GtJsonSimplePersonModelWithoutAccessors,
	#superclass : #GtJsonDictionaryModel,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonSimplePersonModelWithoutAccessors >> jsonModelDefinition [

	^ { 
		  (GtJsonStringModel key: #firstName at: self defaultValue: '').
		  (GtJsonStringModel key: #familyName at: self defaultValue: '').
		  (GtJsonDateModel key: #birthday at: self defaultValue: nil).
		  (GtJsonPostalAdressModel key: #address at: self defaultValue: nil) }
]
