import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yamly/models/data.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject<bool> loading = PublishSubject<bool>();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      } else {
        return Observable.just({ });
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);

    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final user = await _auth.signInWithCredential(credential);
      updateUserData(user);

      return user;
    }
    catch(e){
      loading.add(false);
    }

    loading.add(false);
    return null;
  }

  void updateUserData(FirebaseUser user) async {
    data.user = user;

    final DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName, 
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void addProductLike(int productId)
  {
    _addToArray(productId, 'likedProducts');
  }

  void addProductDislike(int productId)
  {
    _addToArray(productId, 'dislikedProducts');
  }

  void _addToArray(int itemId, String arrayName)
  {
    final DocumentReference ref = _db.collection('users').document(data.user.uid);

    _db.runTransaction((Transaction tx) async {
        DocumentSnapshot snapshot =
            await tx.get(ref);
        var doc = snapshot.data;
        if (doc[arrayName] == null || 
          !doc[arrayName].contains(itemId)) 
        {
          await tx.update(snapshot.reference, <String, dynamic>{
            arrayName: FieldValue.arrayUnion([itemId])
          });
        }
    });
  }

  Future signOut() async {
    _googleSignIn.signOut();
    _auth.signOut();
  }

  Future<bool> checkIfLogged() async {
    final currentUser = await FirebaseAuth.instance.currentUser();

    if (data.user == null) {
      data.user = currentUser;
    }

    return currentUser != null;
  }
}

final AuthService authService = AuthService();