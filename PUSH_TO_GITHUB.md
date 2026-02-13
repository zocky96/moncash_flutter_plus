# Guide: Pousser les changements du package MonCash sur GitHub

## Fichiers ajoutés/modifiés

### Nouveaux fichiers:
- ✅ `test/response_model_test.dart` - Tests pour PaymentResponse (115 lignes, 14 tests)
- ✅ `test/moncash_utils_test.dart` - Tests pour MonCash class (155 lignes, 18 tests)
- ✅ `.github/workflows/test.yml` - CI/CD workflow
- ✅ `.github/ISSUE_TEMPLATE/bug_report.md` - Template pour bugs
- ✅ `.github/ISSUE_TEMPLATE/feature_request.md` - Template pour features
- ✅ `CONTRIBUTING.md` - Guide de contribution

### Fichiers modifiés:
- ✅ `README.md` - Badges corrigés, meilleures instructions
- ✅ `pubspec.yaml` - Homepage URL mise à jour
- ✅ `lib/src/response_model.dart` - Documentation améliorée

## Commandes à exécuter

Ouvrez un nouveau terminal PowerShell et exécutez:

```powershell
# 1. Naviguer vers le répertoire du package
cd C:\Users\Dev\Desktop\dev\moncash_flutter_plus

# 2. Vérifier les changements
git status

# 3. Ajouter tous les nouveaux fichiers et modifications
git add .

# 4. Créer un commit avec un message descriptif
git commit -m "Add comprehensive tests, CI/CD, and improved documentation

- Add unit tests for response_model and moncash_utils (32 tests total)
- Add GitHub Actions CI/CD pipeline with automated testing
- Add issue templates for bugs and feature requests
- Add CONTRIBUTING.md with contribution guidelines
- Fix README badges (removed incorrect ones from another package)
- Update homepage URL to fork repository
- Improve dartdoc comments with examples
- Update installation instructions in README"

# 5. Pousser sur GitHub
git push origin main
```

## Si vous rencontrez des erreurs

### Erreur: "no changes added to commit"
Cela signifie que les fichiers sont déjà commités. Vous pouvez vérifier avec:
```powershell
git log -1
```

### Erreur: "failed to push some refs"
Vous devez d'abord pull les changements distants:
```powershell
git pull origin main --rebase
git push origin main
```

### La branche s'appelle "master" au lieu de "main"
Remplacez `main` par `master` dans les commandes:
```powershell
git push origin master
```

## Après le push

Une fois poussé, votre package aura:
- ✅ Tests automatiques sur chaque push/PR
- ✅ Vérification du formatage et analyse du code
- ✅ Build de l'app exemple
- ✅ Templates pour faciliter les contributions
- ✅ Documentation professionnelle

## Mettre à jour votre app shop

Après avoir poussé, mettez à jour le package dans votre app:

```powershell
cd C:\Users\Dev\Desktop\dev\shop
flutter pub upgrade
flutter pub get
```

Cela récupérera la dernière version depuis GitHub avec tous les tests et améliorations!
