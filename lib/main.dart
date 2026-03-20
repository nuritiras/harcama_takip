import 'package:flutter/material.dart';
import 'api_service.dart';
import 'expense_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harcama Takip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 1. GİRİŞ EKRANI
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // UYARI 1 ÇÖZÜMÜ: State dönüş tipi public yapıldı
  State<LoginScreen> createState() => _LoginScreenState(); 
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    String? token = await apiService.login(_usernameController.text.trim(), _passwordController.text.trim());
    
    // UYARI 2 ÇÖZÜMÜ: async işleminden sonra mounted kontrolü
    if (!mounted) return; 
    
    setState(() => _isLoading = false);

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ExpenseListScreen(token: token)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giriş başarısız!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap', style: TextStyle(color: Colors.white)), backgroundColor: Colors.teal,),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wallet, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Kullanıcı Adı', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Şifre', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 24),
            _isLoading 
                ? const CircularProgressIndicator() 
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)),
                    onPressed: _login,
                    child: const Text('Giriş Yap', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. HARCAMA LİSTESİ EKRANI
// ==========================================
class ExpenseListScreen extends StatefulWidget {
  final String token;
  const ExpenseListScreen({super.key, required this.token});

  @override
  // UYARI 1 ÇÖZÜMÜ
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Expense>> futureExpenses;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      futureExpenses = apiService.getExpenses(widget.token);
    });
  }

  void _deleteExpense(int id) async {
    bool success = await apiService.deleteExpense(widget.token, id);
    
    // UYARI 2 ÇÖZÜMÜ: async işleminden sonra mounted kontrolü
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harcama silindi!')));
      _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silme işlemi başarısız!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harcamalarım', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        child: FutureBuilder<List<Expense>>(
          future: futureExpenses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text("Hata: ${snapshot.error}"));
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Harcama bulunamadı."));

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var expense = snapshot.data![index];
                return Dismissible(
                  key: Key(expense.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _deleteExpense(expense.id),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${expense.category} - ${expense.date}'),
                      trailing: Text('${expense.amount} ₺', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExpenseFormScreen(token: widget.token, expense: expense)),
                        );
                        // UYARI 2 ÇÖZÜMÜ
                        if (!mounted) return;
                        _loadData(); 
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExpenseFormScreen(token: widget.token)),
          );
          // UYARI 2 ÇÖZÜMÜ
          if (!mounted) return;
          _loadData(); 
        },
      ),
    );
  }
}

// ==========================================
// 3. EKLEME VE GÜNCELLEME FORMU EKRANI
// ==========================================
class ExpenseFormScreen extends StatefulWidget {
  final String token;
  final Expense? expense; 

  const ExpenseFormScreen({super.key, required this.token, this.expense});

  @override
  // UYARI 1 ÇÖZÜMÜ
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Diğer';
  final List<String> _categories = ['Yemek', 'Ulaşım', 'Fatura', 'Eğlence', 'Diğer'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount;
      _selectedCategory = _categories.contains(widget.expense!.category) ? widget.expense!.category : 'Diğer';
    }
  }

  void _saveExpense() async {
    setState(() => _isLoading = true);
    bool success;

    if (widget.expense == null) {
      success = await apiService.addExpense(widget.token, _titleController.text, _amountController.text, _selectedCategory);
    } else {
      success = await apiService.updateExpense(widget.token, widget.expense!.id, _titleController.text, _amountController.text, _selectedCategory);
    }

    // UYARI 2 ÇÖZÜMÜ
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İşlem başarısız oldu.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Harcamayı Güncelle' : 'Yeni Harcama Ekle', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Harcama Başlığı')),
            const SizedBox(height: 10),
            TextField(controller: _amountController, decoration: const InputDecoration(labelText: 'Tutar (₺)'), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              // UYARI 3 ÇÖZÜMÜ: value yerine initialValue kullanıldı
              initialValue: _selectedCategory, 
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 30),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, minimumSize: const Size(double.infinity, 50)),
                  onPressed: _saveExpense,
                  child: Text(isEditing ? 'Güncelle' : 'Kaydet', style: const TextStyle(color: Colors.white, fontSize: 18)),
                )
          ],
        ),
      ),
    );
  }
}