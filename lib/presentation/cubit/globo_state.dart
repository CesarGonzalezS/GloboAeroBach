import 'package:equatable/equatable.dart';
import 'package:flutter_globo_front/data/models/globo_model.dart';

abstract class GloboState extends Equatable {
  const GloboState();

  @override
  List<Object> get props => [];
}

class GloboInitial extends GloboState {}

class GloboLoading extends GloboState {}

class GloboSuccess extends GloboState {
  final List<Globo> globos;

  const GloboSuccess({required this.globos});

  @override
  List<Object> get props => [globos];
}

class GloboError extends GloboState {
  final String error;

  const GloboError({required this.error});

  @override
  List<Object> get props => [error];
}
