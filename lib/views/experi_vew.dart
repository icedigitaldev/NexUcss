import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/experi_controller.dart';

class ExperiView extends ConsumerStatefulWidget {
  const ExperiView({Key? key}) : super(key: key);

  @override
  ConsumerState<ExperiView> createState() => _ExperiViewState();
}

class _ExperiViewState extends ConsumerState<ExperiView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(experiControllerProvider.notifier);
    final isOffline = ref.watch(experiControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experimentos'),
        actions: [
          Switch(
            value: isOffline,
            onChanged: (value) {
              controller.toggleOfflineMode();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.addExperimento({
                          'nombre': _nombreController.text,
                          'descripcion': _descripcionController.text,
                        });
                        _nombreController.clear();
                        _descripcionController.clear();
                      }
                    },
                    child: const Text('Agregar Experimento'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: controller.getExperimentos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay experimentos'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var experimento = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(experimento['nombre']),
                      subtitle: Text(experimento['descripcion']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(context, controller, experimento);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              controller.deleteExperimento(experimento.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ExperiController controller, dynamic experimento) {
    final nombreController = TextEditingController(text: experimento['nombre']);
    final descripcionController = TextEditingController(text: experimento['descripcion']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Experimento'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                controller.updateExperimento(experimento.id, {
                  'nombre': nombreController.text,
                  'descripcion': descripcionController.text,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
