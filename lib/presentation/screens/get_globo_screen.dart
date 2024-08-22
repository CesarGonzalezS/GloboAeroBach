import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_globo_front/data/models/globo_model.dart';
import 'package:flutter_globo_front/data/repository/globo_repository.dart';
import '../cubit/globo_cubit.dart';
import '../cubit/globo_state.dart';


class GloboListView extends StatelessWidget {
  const GloboListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GloboCubit(
        globoRepository: RepositoryProvider.of<GloboRepository>(context),
      )..getGlobos(), // Fetch globos initially
      child: const GloboListScreen(),
    );
  }
}

class GloboListScreen extends StatelessWidget {
  const GloboListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globoCubit = BlocProvider.of<GloboCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Globo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _addGlobo(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: globoCubit.getGlobos,
            child: const Text('Fetch Globos'),
          ),
          Expanded(
            child: BlocBuilder<GloboCubit, GloboState>(
              builder: (context, state) {
                if (state is GloboLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GloboSuccess) {
                  final globos = state.globos;
                  if (globos.isEmpty) {
                    return const Center(child: Text('No globos available. Please add a globo.'));
                  }
                  return ListView.builder(
                    itemCount: globos.length,
                    itemBuilder: (context, index) {
                      final globo = globos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            globo.nombre,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fabricante: ${globo.fabricante}'),
                              Text('Altura Máxima: ${globo.alturaMaxima} m'),
                              Text('Capacidad: ${globo.capacidad} personas'),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editGlobo(context, globo);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  if (globo.id != null) {
                                    _deleteGlobo(context, globo.id!);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is GloboError) {
                  return Center(child: Text(state.error));
                }
                return const Center(child: Text('Press the button to fetch globos'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addGlobo(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addGlobo(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final nombreController = TextEditingController();
        final fabricanteController = TextEditingController();
        final alturaMaximaController = TextEditingController();
        final capacidadController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Globo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: fabricanteController,
                decoration: const InputDecoration(labelText: 'Fabricante'),
              ),
              TextField(
                controller: alturaMaximaController,
                decoration: const InputDecoration(labelText: 'Altura Máxima'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newGlobo = Globo(
                  id: 0, // ID will be assigned by the backend
                  nombre: nombreController.text,
                  fabricante: fabricanteController.text,
                  alturaMaxima: int.tryParse(alturaMaximaController.text) ?? 0,
                  capacidad: int.tryParse(capacidadController.text) ?? 0,
                );
                BlocProvider.of<GloboCubit>(context).createGlobo(newGlobo);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editGlobo(BuildContext context, Globo globo) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final nombreController = TextEditingController(text: globo.nombre);
        final fabricanteController = TextEditingController(text: globo.fabricante);
        final alturaMaximaController = TextEditingController(text: globo.alturaMaxima.toString());
        final capacidadController = TextEditingController(text: globo.capacidad.toString());
        return AlertDialog(
          title: const Text('Edit Globo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: fabricanteController,
                decoration: const InputDecoration(labelText: 'Fabricante'),
              ),
              TextField(
                controller: alturaMaximaController,
                decoration: const InputDecoration(labelText: 'Altura Máxima'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: capacidadController,
                decoration: const InputDecoration(labelText: 'Capacidad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedGlobo = Globo(
                  id: globo.id, // Ensure the ID is passed for the update
                  nombre: nombreController.text,
                  fabricante: fabricanteController.text,
                  alturaMaxima: int.tryParse(alturaMaximaController.text) ?? globo.alturaMaxima,
                  capacidad: int.tryParse(capacidadController.text) ?? globo.capacidad,
                );
                BlocProvider.of<GloboCubit>(context).updateGlobo(updatedGlobo);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteGlobo(BuildContext context, int globoId) {
    BlocProvider.of<GloboCubit>(context).deleteGlobo(globoId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Globo deleted successfully'),
      ),
    );
  }
}