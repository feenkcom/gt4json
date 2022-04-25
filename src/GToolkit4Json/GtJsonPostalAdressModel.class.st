Class {
	#name : #GtJsonPostalAdressModel,
	#superclass : #GtJsonCompositeModel,
	#category : #'GToolkit4Json-Examples'
}

{ #category : #accessing }
GtJsonPostalAdressModel >> city [

	^ self valueAt: #city
]

{ #category : #accessing }
GtJsonPostalAdressModel >> city: aString [

	self valueAt: #city put: aString
]

{ #category : #accessing }
GtJsonPostalAdressModel >> isPrimary [

	^ self valueAt: #is_primary
]

{ #category : #accessing }
GtJsonPostalAdressModel >> isPrimary: aBoolean [

	self valueAt: #is_primary put: aBoolean
]

{ #category : #accessing }
GtJsonPostalAdressModel >> jsonModelDefinition [

	^ { 
		  (GtJsonStringModel key: 'street' at: self defaultValue: '').
		  (GtJsonStringModel key: 'city' at: self defaultValue: '').
		  (GtJsonBooleanModel key: 'is_primary' at: self defaultValue: false) }
]

{ #category : #accessing }
GtJsonPostalAdressModel >> street [

	^ self valueAt: #street
]

{ #category : #accessing }
GtJsonPostalAdressModel >> street: aString [

	self valueAt: #street put: aString
]
