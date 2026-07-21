// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rocketchat_creds.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RocketChatCreds {

 String get baseUrl; String get username; String get userId; String get authToken; String get botRoomId;
/// Create a copy of RocketChatCreds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RocketChatCredsCopyWith<RocketChatCreds> get copyWith => _$RocketChatCredsCopyWithImpl<RocketChatCreds>(this as RocketChatCreds, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RocketChatCreds&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.username, username) || other.username == username)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.authToken, authToken) || other.authToken == authToken)&&(identical(other.botRoomId, botRoomId) || other.botRoomId == botRoomId));
}


@override
int get hashCode => Object.hash(runtimeType,baseUrl,username,userId,authToken,botRoomId);

@override
String toString() {
  return 'RocketChatCreds(baseUrl: $baseUrl, username: $username, userId: $userId, authToken: $authToken, botRoomId: $botRoomId)';
}


}

/// @nodoc
abstract mixin class $RocketChatCredsCopyWith<$Res>  {
  factory $RocketChatCredsCopyWith(RocketChatCreds value, $Res Function(RocketChatCreds) _then) = _$RocketChatCredsCopyWithImpl;
@useResult
$Res call({
 String baseUrl, String username, String userId, String authToken, String botRoomId
});




}
/// @nodoc
class _$RocketChatCredsCopyWithImpl<$Res>
    implements $RocketChatCredsCopyWith<$Res> {
  _$RocketChatCredsCopyWithImpl(this._self, this._then);

  final RocketChatCreds _self;
  final $Res Function(RocketChatCreds) _then;

/// Create a copy of RocketChatCreds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseUrl = null,Object? username = null,Object? userId = null,Object? authToken = null,Object? botRoomId = null,}) {
  return _then(_self.copyWith(
baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,authToken: null == authToken ? _self.authToken : authToken // ignore: cast_nullable_to_non_nullable
as String,botRoomId: null == botRoomId ? _self.botRoomId : botRoomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RocketChatCreds].
extension RocketChatCredsPatterns on RocketChatCreds {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RocketChatCreds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RocketChatCreds() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RocketChatCreds value)  $default,){
final _that = this;
switch (_that) {
case _RocketChatCreds():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RocketChatCreds value)?  $default,){
final _that = this;
switch (_that) {
case _RocketChatCreds() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String baseUrl,  String username,  String userId,  String authToken,  String botRoomId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RocketChatCreds() when $default != null:
return $default(_that.baseUrl,_that.username,_that.userId,_that.authToken,_that.botRoomId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String baseUrl,  String username,  String userId,  String authToken,  String botRoomId)  $default,) {final _that = this;
switch (_that) {
case _RocketChatCreds():
return $default(_that.baseUrl,_that.username,_that.userId,_that.authToken,_that.botRoomId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String baseUrl,  String username,  String userId,  String authToken,  String botRoomId)?  $default,) {final _that = this;
switch (_that) {
case _RocketChatCreds() when $default != null:
return $default(_that.baseUrl,_that.username,_that.userId,_that.authToken,_that.botRoomId);case _:
  return null;

}
}

}

/// @nodoc


class _RocketChatCreds implements RocketChatCreds {
  const _RocketChatCreds({required this.baseUrl, required this.username, required this.userId, required this.authToken, required this.botRoomId});
  

@override final  String baseUrl;
@override final  String username;
@override final  String userId;
@override final  String authToken;
@override final  String botRoomId;

/// Create a copy of RocketChatCreds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RocketChatCredsCopyWith<_RocketChatCreds> get copyWith => __$RocketChatCredsCopyWithImpl<_RocketChatCreds>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RocketChatCreds&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl)&&(identical(other.username, username) || other.username == username)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.authToken, authToken) || other.authToken == authToken)&&(identical(other.botRoomId, botRoomId) || other.botRoomId == botRoomId));
}


@override
int get hashCode => Object.hash(runtimeType,baseUrl,username,userId,authToken,botRoomId);

@override
String toString() {
  return 'RocketChatCreds(baseUrl: $baseUrl, username: $username, userId: $userId, authToken: $authToken, botRoomId: $botRoomId)';
}


}

/// @nodoc
abstract mixin class _$RocketChatCredsCopyWith<$Res> implements $RocketChatCredsCopyWith<$Res> {
  factory _$RocketChatCredsCopyWith(_RocketChatCreds value, $Res Function(_RocketChatCreds) _then) = __$RocketChatCredsCopyWithImpl;
@override @useResult
$Res call({
 String baseUrl, String username, String userId, String authToken, String botRoomId
});




}
/// @nodoc
class __$RocketChatCredsCopyWithImpl<$Res>
    implements _$RocketChatCredsCopyWith<$Res> {
  __$RocketChatCredsCopyWithImpl(this._self, this._then);

  final _RocketChatCreds _self;
  final $Res Function(_RocketChatCreds) _then;

/// Create a copy of RocketChatCreds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseUrl = null,Object? username = null,Object? userId = null,Object? authToken = null,Object? botRoomId = null,}) {
  return _then(_RocketChatCreds(
baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,authToken: null == authToken ? _self.authToken : authToken // ignore: cast_nullable_to_non_nullable
as String,botRoomId: null == botRoomId ? _self.botRoomId : botRoomId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
