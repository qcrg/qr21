// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrData {

 String get username; String get src; DateTime get expires;
/// Create a copy of QrData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrDataCopyWith<QrData> get copyWith => _$QrDataCopyWithImpl<QrData>(this as QrData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrData&&(identical(other.username, username) || other.username == username)&&(identical(other.src, src) || other.src == src)&&(identical(other.expires, expires) || other.expires == expires));
}


@override
int get hashCode => Object.hash(runtimeType,username,src,expires);

@override
String toString() {
  return 'QrData(username: $username, src: $src, expires: $expires)';
}


}

/// @nodoc
abstract mixin class $QrDataCopyWith<$Res>  {
  factory $QrDataCopyWith(QrData value, $Res Function(QrData) _then) = _$QrDataCopyWithImpl;
@useResult
$Res call({
 String username, String src, DateTime expires
});




}
/// @nodoc
class _$QrDataCopyWithImpl<$Res>
    implements $QrDataCopyWith<$Res> {
  _$QrDataCopyWithImpl(this._self, this._then);

  final QrData _self;
  final $Res Function(QrData) _then;

/// Create a copy of QrData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? src = null,Object? expires = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,expires: null == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QrData].
extension QrDataPatterns on QrData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrData value)  $default,){
final _that = this;
switch (_that) {
case _QrData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrData value)?  $default,){
final _that = this;
switch (_that) {
case _QrData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String src,  DateTime expires)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrData() when $default != null:
return $default(_that.username,_that.src,_that.expires);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String src,  DateTime expires)  $default,) {final _that = this;
switch (_that) {
case _QrData():
return $default(_that.username,_that.src,_that.expires);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String src,  DateTime expires)?  $default,) {final _that = this;
switch (_that) {
case _QrData() when $default != null:
return $default(_that.username,_that.src,_that.expires);case _:
  return null;

}
}

}

/// @nodoc


class _QrData implements QrData {
  const _QrData({required this.username, required this.src, required this.expires});
  

@override final  String username;
@override final  String src;
@override final  DateTime expires;

/// Create a copy of QrData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrDataCopyWith<_QrData> get copyWith => __$QrDataCopyWithImpl<_QrData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrData&&(identical(other.username, username) || other.username == username)&&(identical(other.src, src) || other.src == src)&&(identical(other.expires, expires) || other.expires == expires));
}


@override
int get hashCode => Object.hash(runtimeType,username,src,expires);

@override
String toString() {
  return 'QrData(username: $username, src: $src, expires: $expires)';
}


}

/// @nodoc
abstract mixin class _$QrDataCopyWith<$Res> implements $QrDataCopyWith<$Res> {
  factory _$QrDataCopyWith(_QrData value, $Res Function(_QrData) _then) = __$QrDataCopyWithImpl;
@override @useResult
$Res call({
 String username, String src, DateTime expires
});




}
/// @nodoc
class __$QrDataCopyWithImpl<$Res>
    implements _$QrDataCopyWith<$Res> {
  __$QrDataCopyWithImpl(this._self, this._then);

  final _QrData _self;
  final $Res Function(_QrData) _then;

/// Create a copy of QrData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? src = null,Object? expires = null,}) {
  return _then(_QrData(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,expires: null == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
