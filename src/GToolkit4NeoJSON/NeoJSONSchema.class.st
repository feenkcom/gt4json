"
I am NeoJSONSchema, an implementation of JSON Schema.

I implement

- https://json-schema.org 
- https://json-schema.org/draft/2020-12/json-schema-core.html
- https://json-schema.org/draft/2020-12/json-schema-validation.html
- https://www.learnjsonschema.com/2020-12/

The goal of JSON Schema is to enable the confident and reliable use of the JSON data format.
"
Class {
	#name : #NeoJSONSchema,
	#superclass : #Object,
	#instVars : [
		'raw'
	],
	#category : #'GToolkit4NeoJSON-Schema'
}

{ #category : #accessing }
NeoJSONSchema class >> metaSchema [
	<gtExample>
	
	| jsonString json |
	jsonString := NeoJSONSchemaStore uniqueInstance schemaAt: self metaSchemaUrl.
	json := NeoJSONObject fromString: jsonString.
	^ self new json: json
]

{ #category : #accessing }
NeoJSONSchema class >> metaSchemaUrl [
	^ 'https://json-schema.org/draft/2020-12/schema' asUrl
]

{ #category : #vocabulary }
NeoJSONSchema >> additionalProperties [
	^ self rawProperties at: #additionalProperties
]

{ #category : #vocabulary }
NeoJSONSchema >> allOf [
	^ self rawProperties at: #allOf
]

{ #category : #vocabulary }
NeoJSONSchema >> anchor [
	^ self rawProperties at: '$anchor'
]

{ #category : #vocabulary }
NeoJSONSchema >> anyOf [
	^ self rawProperties at: #anyOf
]

{ #category : #vocabulary }
NeoJSONSchema >> comment [
	^ self rawProperties at: '$comment'
]

{ #category : #vocabulary }
NeoJSONSchema >> const [
	^ self rawProperties at: #const
]

{ #category : #vocabulary }
NeoJSONSchema >> contains [
	^ self rawProperties at: #contains
]

{ #category : #vocabulary }
NeoJSONSchema >> contentEncoding [
	^ self rawProperties at: #contentEncoding
]

{ #category : #vocabulary }
NeoJSONSchema >> contentMediaType [
	^ self rawProperties at: #contentMediaType ifPresent: [ :string | string asMIMEType ]
]

{ #category : #vocabulary }
NeoJSONSchema >> default [
	^ self rawProperties at: #default
]

{ #category : #vocabulary }
NeoJSONSchema >> defs [
	^ self rawProperties at: '$defs'
]

{ #category : #vocabulary }
NeoJSONSchema >> dependentRequired [
	^ self rawProperties at: #dependentRequired
]

{ #category : #vocabulary }
NeoJSONSchema >> dependentSchemas [
	^ self rawProperties at: #dependentSchemas
]

{ #category : #vocabulary }
NeoJSONSchema >> deprecated [
	^ self rawProperties at: #deprecated
]

{ #category : #vocabulary }
NeoJSONSchema >> description [
	^ self rawProperties at: #description
]

{ #category : #vocabulary }
NeoJSONSchema >> dynamicAnchor [
	^ self rawProperties at: '$dynamicAnchor'
]

{ #category : #vocabulary }
NeoJSONSchema >> dynamicRef [
	^ self rawProperties at: '$dynamicRef'
]

{ #category : #vocabulary }
NeoJSONSchema >> else [
	^ self rawProperties at: #else
]

{ #category : #vocabulary }
NeoJSONSchema >> enum [
	^ self rawProperties at: #enum
]

{ #category : #vocabulary }
NeoJSONSchema >> examples [
	^ self rawProperties at: #examples
]

{ #category : #vocabulary }
NeoJSONSchema >> exclusiveMaximum [
	^ self rawProperties at: #exclusiveMaximum
]

{ #category : #vocabulary }
NeoJSONSchema >> exclusiveMinimum [
	^ self rawProperties at: #exclusiveMinimum
]

{ #category : #vocabulary }
NeoJSONSchema >> format [
	^ self rawProperties at: #format
]

{ #category : #'gt extensions' }
NeoJSONSchema >> gtDetails [
	| details vocabulary subSchemas subSchemaMaps subSchemaLists printStrings special |
	details := OrderedCollection new.
	vocabulary := self recognisedVocabulary 
		collect: [ :each | each isSymbol ifTrue: [ each -> each ] ifFalse: [ each first -> each second ] ] 
		as: OrderedDictionary.
	subSchemas := #(items contains not if then else propertyNames unevaluatedItems unevaluatedProperties additionalProperties).
	subSchemaLists := #(allOf anyOf oneOf prefixItems).
	subSchemaMaps := #(properties defs patternProperties).
	printStrings := #(required enum const default).
	special := subSchemas , subSchemaLists , subSchemaMaps , printStrings.
	vocabulary keys do: [ :key |
		(special includes: key) ifFalse: [
			(self perform: key) ifNotNil: [ :value |
				details add: { vocabulary at: key . value } ] ] ].
	subSchemas do: [ :key |
		(self perform: key) ifNotNil: [ :value |
			details add: { vocabulary at: key . self resolveSubSchema: value } ] ].
	subSchemaLists do: [ :key |
		(self perform: key) ifNotNil: [ :list |
			details add: { vocabulary at: key . (list collect: [ :each | self resolveSubSchema: each ]) as: Array } ] ].
	subSchemaMaps do: [ :key |
		(self perform: key) ifNotNil: [ :map |
			details add: { vocabulary at: key . (map collect: [ :each | self resolveSubSchema: each ]) as: Dictionary } ] ].			
	printStrings do: [ :key |
		(self perform: key) ifNotNil: [ :value |
			details add: { vocabulary at: key . value printString . value } ] ].
	 ^ details
]

{ #category : #'gt extensions' }
NeoJSONSchema >> gtViewDefsIn: aComposite [
	<gtView>
	self defs ifNil: [ ^ aComposite empty ].
	^ aComposite forward
		  title: 'Defs';
		  priority: 40;
		  object: [ (self defs collect: [ :each | self resolveSubSchema:  each ]) asDictionary ];
		  view: #gtItemsFor:
]

{ #category : #'gt extensions' }
NeoJSONSchema >> gtViewDetailsIn: aComposite [
	<gtView>
	^ aComposite columnedList
		  title: 'Schema';
		  priority: 20;
		  items: [ self gtDetails ];
		  column: 'Key' text: #first;
		  column: 'Value' text: #second weight: 3;
		  send: #last
]

{ #category : #'gt extensions' }
NeoJSONSchema >> gtViewPropertiesIn: aComposite [
	<gtView>
	self properties ifNil: [ ^ aComposite empty ].
	^ aComposite forward
		  title: 'Properties';
		  priority: 30;
		  object: [ (self properties collect: [ :each | self resolveSubSchema:  each ]) asDictionary ];
		  view: #gtItemsFor:
]

{ #category : #'gt extensions' }
NeoJSONSchema >> gtViewRawJsonIn: aComposite [
	<gtView>
	self raw isDictionary ifFalse: [ ^ aComposite empty ].
	^ aComposite forward
		  title: 'Raw JSON';
		  priority: 50;
		  object: [ self json ];
		  view: #gtJsonFor:
]

{ #category : #vocabulary }
NeoJSONSchema >> idUrl [
	^ self rawProperties at: '$id' ifPresent: [ :string | string asUrl ]
]

{ #category : #vocabulary }
NeoJSONSchema >> if [
	^ self rawProperties at: #if
]

{ #category : #initialization }
NeoJSONSchema >> initialize [
	super initialize.
	raw := NeoJSONObject new
]

{ #category : #testing }
NeoJSONSchema >> isDeprecated [
	^ self deprecated ifNil: [ false ]
]

{ #category : #testing }
NeoJSONSchema >> isEmpty [
	^ raw isDictionary and: [ raw isEmpty ]
]

{ #category : #testing }
NeoJSONSchema >> isReadOnly [
	^ self readOnly ifNil: [ false ]
]

{ #category : #testing }
NeoJSONSchema >> isWriteOnly [
	^ self writeOnly ifNil: [ false ]
]

{ #category : #vocabulary }
NeoJSONSchema >> items [
	^ self rawProperties at: #items
]

{ #category : #accessing }
NeoJSONSchema >> json [
	^ self raw
]

{ #category : #accessing }
NeoJSONSchema >> json: jsonObject [
	self raw: jsonObject
]

{ #category : #vocabulary }
NeoJSONSchema >> maxContains [
	^ self rawProperties at: #maxContains
]

{ #category : #vocabulary }
NeoJSONSchema >> maxItems [
	^ self rawProperties at: #maxItems
]

{ #category : #vocabulary }
NeoJSONSchema >> maxLength [
	^ self rawProperties at: #maxLength
]

{ #category : #vocabulary }
NeoJSONSchema >> maxProperties [
	^ self rawProperties at: #maxProperties
]

{ #category : #vocabulary }
NeoJSONSchema >> maximum [
	^ self rawProperties at: #maximum
]

{ #category : #validation }
NeoJSONSchema >> metaValidate [
	| metaSchema metaValidator |
	metaSchema := self class metaSchema.
	metaValidator := metaSchema validator.
	metaValidator validate: self json.
	^ metaValidator
]

{ #category : #vocabulary }
NeoJSONSchema >> minContains [
	^ self rawProperties at: #minContains
]

{ #category : #vocabulary }
NeoJSONSchema >> minItems [
	^ self rawProperties at: #minItems
]

{ #category : #vocabulary }
NeoJSONSchema >> minLength [
	^ self rawProperties at: #minLength
]

{ #category : #vocabulary }
NeoJSONSchema >> minProperties [
	^ self rawProperties at: #minProperties
]

{ #category : #vocabulary }
NeoJSONSchema >> minimum [
	^ self rawProperties at: #minimum
]

{ #category : #vocabulary }
NeoJSONSchema >> multipleOf [
	^ self rawProperties at: #multipleOf
]

{ #category : #accessing }
NeoJSONSchema >> newSubSchema [
	^ NeoJSONSubSchema new
		root: self root
]

{ #category : #vocabulary }
NeoJSONSchema >> not [
	^ self rawProperties at: #not
]

{ #category : #vocabulary }
NeoJSONSchema >> oneOf [
	^ self rawProperties at: #oneOf
]

{ #category : #vocabulary }
NeoJSONSchema >> pattern [
	^ self rawProperties at: #pattern
]

{ #category : #vocabulary }
NeoJSONSchema >> patternProperties [
	^ self rawProperties at: #patternProperties
]

{ #category : #vocabulary }
NeoJSONSchema >> prefixItems [
	^ self rawProperties at: #prefixItems
]

{ #category : #printing }
NeoJSONSchema >> printOn: stream [
	super printOn: stream.
	self title ifNotNil: [ :title |
		stream nextPut: $(; nextPutAll: title; nextPut: $) ]
]

{ #category : #vocabulary }
NeoJSONSchema >> properties [
	^ self rawProperties at: #properties
]

{ #category : #vocabulary }
NeoJSONSchema >> propertyNames [
	^ self rawProperties at: #propertyNames
]

{ #category : #accessing }
NeoJSONSchema >> raw [
	^ raw
]

{ #category : #accessing }
NeoJSONSchema >> raw: jsonObject [
	raw := jsonObject
]

{ #category : #accessing }
NeoJSONSchema >> rawProperties [
	"Allow for true and false to be used as raw schema"
	
	^ raw isDictionary ifTrue: [ raw ] ifFalse: [ NeoJSONObject new ]
]

{ #category : #vocabulary }
NeoJSONSchema >> readOnly [
	^ self rawProperties at: #readOnly
]

{ #category : #accessing }
NeoJSONSchema >> recognisedVocabulary [
	^ #(
		(schemaUrl '$schema') (idUrl '$id') type 
		title description examples
		readOnly writeOnly deprecated
		minLength maxLength pattern format
		multipleOf minimum exclusiveMinimum maximum exclusiveMaximum
		properties patternProperties additionalProperties unevaluatedProperties required propertyNames minProperties maxProperties
		items prefixItems unevaluatedItems contains minContains maxContains minItems maxItems uniqueItems
		enum const default
		contentMediaType contentEncoding
		allOf anyOf oneOf not
		dependentRequired dependentSchemas if then else
		(ref '$ref') (defs '$defs') (anchor '$anchor')
		(dynamicRef '$dynamicRef') (dynamicAnchor '$dynamicAnchor')
		(comment '$comment') (vocabulary '$vocubulary')
	)
]

{ #category : #vocabulary }
NeoJSONSchema >> ref [
	^ self rawProperties at: '$ref'
]

{ #category : #vocabulary }
NeoJSONSchema >> required [
	^ self rawProperties at: #required
]

{ #category : #accessing }
NeoJSONSchema >> resolveJSONPointer: jsonPointer [
	| url fragment |
	url := jsonPointer asUrl.
	url hasScheme | url hasHost | url hasPort | url hasPath
		ifTrue: [ ^ nil ].
	url hasFragment
		ifFalse: [ ^ nil ].
	fragment := url fragment.
	^ fragment first = $/
		ifTrue: [
			self root json atPath: ($/ split: url fragment) allButFirst ]
		ifFalse: [
			(self json findPath: [ :object | object isDictionary and: [ (object at: '$anchor') = fragment ] ])
				ifNotNil: [ :path |
					self json atPath: path ] ]
]

{ #category : #accessing }
NeoJSONSchema >> resolveRef: reference [
	| url resolvedUrl urlWithoutFragment jsonString json |
	reference = '#' ifTrue: [ ^ self root ].
	url := reference asUrl.
	(self resolveJSONPointer: url)
		ifNotNil: [ :resolvedJson | ^ self newSubSchema json: resolvedJson ].
	resolvedUrl := self root schemaUrl withRelativeReference: reference.
	urlWithoutFragment := resolvedUrl copy fragment: nil.
	jsonString := NeoJSONSchemaStore uniqueInstance schemaAt: urlWithoutFragment.
	json := NeoJSONObject fromString: jsonString.
	resolvedUrl hasFragment
		ifTrue: [ json := json atPath: ($/ split: resolvedUrl fragment) allButFirst ].
	^ NeoJSONSchema new json: json
]

{ #category : #accessing }
NeoJSONSchema >> resolveSubSchema: jsonObject [
	jsonObject isDictionary
		ifTrue: [ 
			(jsonObject at: '$ref')
				ifNotNil: [ :ref | 
					(self resolveRef: ref)
						ifNotNil: [ :resolvedSchema | ^ resolvedSchema ] ] ].
	"fallback"
	^ self newSubSchema json: jsonObject
]

{ #category : #accessing }
NeoJSONSchema >> root [
	^ self
]

{ #category : #vocabulary }
NeoJSONSchema >> schemaUrl [
	^ self rawProperties at: '$schema' ifPresent: [ :string | string asUrl ]
]

{ #category : #vocabulary }
NeoJSONSchema >> then [
	^ self rawProperties at: #then
]

{ #category : #vocabulary }
NeoJSONSchema >> title [
	^ self rawProperties at: #title
]

{ #category : #vocabulary }
NeoJSONSchema >> type [
	^ self rawProperties at: #type
]

{ #category : #vocabulary }
NeoJSONSchema >> unevaluatedItems [
	^ self rawProperties at: #unevaluatedItems
]

{ #category : #vocabulary }
NeoJSONSchema >> unevaluatedProperties [
	^ self rawProperties at: #unevaluatedProperties
]

{ #category : #vocabulary }
NeoJSONSchema >> uniqueItems [
	^ self rawProperties at: #uniqueItems
]

{ #category : #validation }
NeoJSONSchema >> validate: jsonInstance [
	^ self validator validate: jsonInstance
]

{ #category : #validation }
NeoJSONSchema >> validator [
	^ NeoJSONSchemaValidator new
		schema: self
]

{ #category : #accessing }
NeoJSONSchema >> vocabulary [
	^ self rawProperties at: '$vocabulary'
]

{ #category : #vocabulary }
NeoJSONSchema >> writeOnly [
	^ self rawProperties at: #writeOnly
]
