import 'package:bloc/bloc.dart';
import 'package:flutter_globo_front/data/models/globo_model.dart';
import 'package:flutter_globo_front/data/repository/globo_repository.dart';

import 'globo_state.dart';

class GloboCubit extends Cubit<GloboState> {
  final GloboRepository globoRepository;

  GloboCubit({required this.globoRepository}) : super(GloboInitial());

  Future<void> createGlobo(Globo globo) async {
    try {
      emit(GloboLoading());
      await globoRepository.createGlobo(globo);
      final globos = await globoRepository.getGlobos();
      emit(GloboSuccess(globos: globos));
    } catch (e) {
      emit(GloboError(error: e.toString()));
    }
  }

  Future<void> getGlobos() async {
    try {
      emit(GloboLoading());
      final globos = await globoRepository.getGlobos();
      emit(GloboSuccess(globos: globos));
    } catch (e) {
      emit(GloboError(error: e.toString()));
    }
  }

  Future<void> getGlobo(int id) async {
    try {
      emit(GloboLoading());
      final globo = await globoRepository.getGlobo(id);
      emit(GloboSuccess(globos: [globo]));
    } catch (e) {
      emit(GloboError(error: e.toString()));
    }
  }

  Future<void> updateGlobo(Globo globo) async {
    try {
      emit(GloboLoading());
      await globoRepository.updateGlobo(globo);
      final globos = await globoRepository.getGlobos();
      emit(GloboSuccess(globos: globos));
    } catch (e) {
      emit(GloboError(error: e.toString()));
    }
  }

  Future<void> deleteGlobo(int id) async {
    try {
      emit(GloboLoading());
      await globoRepository.deleteGlobo(id);
      final globos = await globoRepository.getGlobos();
      emit(GloboSuccess(globos: globos));
    } catch (e) {
      emit(GloboError(error: e.toString()));
    }
  }
}
