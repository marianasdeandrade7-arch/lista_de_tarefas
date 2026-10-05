
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class Tarefa {
  final String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do MinimaList',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00BFA5),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const TarefaScreen(),
    );
  }
}


class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});

  @override
  State<TarefaScreen> createState() => _TarefaScreenState();
}

class _TarefaScreenState extends State<TarefaScreen> {

  // Lista de tarefas
  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovo',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder e-mails do trabalho',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Estudar Flutter',
    ),
  ];

  // Controlador do campo de texto
  final TextEditingController _controller = TextEditingController();


  void _abrirBottomSheet() {
    _controller.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Campo de texto
              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Digite uma tarefa...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _adicionarTarefa,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Adicionar tarefa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _adicionarTarefa() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) {
      return;
    }

    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();

    Navigator.pop(context);
  }

  
  void _alternarStatus(String id) {
    setState(() {
      final tarefa = _tarefas.firstWhere(
        (tarefa) => tarefa.id == id,
      );

      tarefa.concluida = !tarefa.concluida;
    });
  }

  
  void _deletarTarefa(String id) {
    setState(() {
      _tarefas.removeWhere(
        (tarefa) => tarefa.id == id,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    final pendentes = _tarefas
        .where((tarefa) => !tarefa.concluida)
        .length;

    return Scaffold(

      backgroundColor: const Color(0xFFF2F2F2),

    
      appBar: AppBar(
        title: const Text(
          '2Do MinimaList',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Center(
              child: Text(
                '$pendentes pendentes',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),

      body: _tarefas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa cadastrada.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 100,
              ),

              itemCount: _tarefas.length,

              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];

                // Permite deslizar para excluir
                return Dismissible(
                  key: ValueKey(tarefa.id),

                  direction: DismissDirection.endToStart,

                  background: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),

                  onDismissed: (_) {
                    _deletarTarefa(tarefa.id);
                  },

                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),

                    child: ListTile(

                      // Checkbox
                      leading: Checkbox(
                        value: tarefa.concluida,

                        activeColor: const Color(0xFF00BFA5),

                        onChanged: (_) {
                          _alternarStatus(tarefa.id);
                        },
                      ),

                      // Nome da tarefa
                      title: Text(
                        tarefa.titulo,

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,

                          decoration: tarefa.concluida
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,

                          color: tarefa.concluida
                              ? Colors.grey
                              : const Color(0xFF2D2D2D),
                        ),
                      ),

                      // Status
                      subtitle: Text(
                        tarefa.concluida
                            ? 'Concluída'
                            : 'Pendente',

                        style: TextStyle(
                          color: tarefa.concluida
                              ? const Color(0xFF00BFA5)
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirBottomSheet,

        backgroundColor: const Color(0xFF00BFA5),
        foregroundColor: Colors.white,

        icon: const Icon(Icons.add),

        label: const Text(
          'Nova tarefa',
        ),
      ),
    );
  }
}
