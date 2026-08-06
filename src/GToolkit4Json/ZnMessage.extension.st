Extension { #name : #ZnMessage }

{ #category : #'*GToolkit4Json' }
ZnMessage >> asGtJson [
	^ GtJson forJsonString: self contents
]

{ #category : #'*GToolkit4Json' }
ZnMessage >> asJson [
	self
		deprecated: 'Please use #asGtJson instead.'
		transformWith: '`@receiver asJson' -> '`@receiver asGtJson'.
		
	^ self asGtJson
]

{ #category : #'*GToolkit4Json' }
ZnMessage >> gtJsonContents [
	"Answer the receiver's value decoded.
	Must have a json sub-type."

	self assert: self contentType sub = 'json'.
	^ NeoJSONReader fromString: self contents
]
