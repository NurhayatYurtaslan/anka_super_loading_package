---
name: repo-commit-messages
description: >-
  Bu repoda git commit mesajlarını `commits.md` ile hizalar: izin verilen
  type listesi, mesaj şablonu ve imza satırı. Kullanıcı commit, git commit,
  conventional commit, stage, PR öncesi özet veya `commits.md` dediğinde
  kullan.
---

# Repo commit mesajları

## Kaynak

Tüm commit **type** değerleri ve anlamları `commits.md` içinde listelenmiştir. Özet (liste değişirse dosyayı oku):

`feat`, `fix`, `chore`, `refactor`, `docs`, `style`, `test`, `perf`, `ci`, `build`, `revert`, `add`, `remove`, `update`, `rename`, `move`, `copy`, `security`, `hotfix`

## Adımlar

1. Değişikliği sınıflandır: yukarıdaki türlerden **birini** seç; birden fazla ana tema varsa mantıklı şekilde böl veya en baskın türü kullan.
2. Özet satırı: `type: 50 karakteri aşmayan, emir kipi veya konu cümlesi` (gerekirse `type(scope): ...`).
3. Gövde: breaking change, migration veya review için gerekliyse ekle.
4. Mesajın **son satırı** tam olarak şu olmalıdır (commits.md):

   `signed by the author @gurkanfikretgunak`

5. Kullanıcıya önermeden önce type’ın `commits.md` ile uyumunu kontrol et.

## Örnekler

**fix**

```
fix: null guard when loading cached preferences

signed by the author @gurkanfikretgunak
```

**chore**

```
chore: bump example app iOS deployment target

signed by the author @gurkanfikretgunak
```

**refactor**

```
refactor: extract session refresh into service

signed by the author @gurkanfikretgunak
```

## Çok dosya / karma değişiklik

Özet satırında en önemli etkiyi yansıt; gövdede diğer başlıkları kısaca listele. Gerekirse kullanıcıya iki ayrı commit öner.
