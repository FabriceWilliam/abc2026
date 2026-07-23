# abc2026 — guide officiel ABC Chicago 2026

Fichier unique : `index.html`. Tout est en ligne — CSS, JS, images en base64.
Production : https://fabricewilliam.github.io/abc2026/ (GitHub Pages, branche `main`).
Événement : 4–6 septembre 2026, Tinley Park Convention Center.

## Contraintes absolues

1. **Le dépôt est PUBLIC.** Aucune clé d'API dans `index.html`, jamais. Le bin JSONBin est en lecture publique : `fetchLiveStatus()` fait un `fetch` sans en-tête d'authentification. Ne jamais ajouter `X-Access-Key` ni `X-Master-Key`. La clé d'écriture vit uniquement dans `ABC_Admin_Control.html`, saisie à la main.
2. **Ne pas modifier la logique métier** : `fetchLiveStatus`, `build`, `applyFlash`, `setLang`, `adaptToEmbedding`, `tickClock`, les `setInterval`, `SYNC_URL`, `OVERRIDES`, `FLASH`, `SIM`. Le système de statuts en direct est validé de bout en bout.
3. **Ne pas supprimer `#vo-splash`** (splash VeyraOps, 2 s, CSS pur). Restylable, mais il doit rester sans JavaScript : si un script casse, le splash doit disparaître quand même.
4. **Ne pas casser le bilingue FR/EN** ni les statuts calculés sur l'heure de Chicago.
5. Travailler sur une branche. Ne jamais pousser sur `main` sans validation explicite.

## Palette — 7 valeurs, aucune autre

Issue des logos officiels (sceau ABC North America, bandeau Chicago 2026, logo IBA).

```
--brand-paper  #F4F5FB   fond de page
--brand-card   #FFFFFF   cartes
--brand-navy   #073676   texte, structure
--brand-sky    #56C1EC   fonds et accents
--brand-red    #E82428   statut « en direct » et CTA
--brand-ink2   #5E6B7E   texte secondaire
--brand-line   #E3E8F1   filets et bordures
```

Le doré, le violet et le turquoise sont hors charte.

## Règles de couleur

Ratios WCAG mesurés :

| Combinaison | Ratio |
|---|---|
| Blanc sur bleu ciel | 2,05:1 — interdit |
| Bleu ciel sur blanc | 2,05:1 — interdit |
| Marine sur bleu ciel | 5,69:1 |
| Marine sur blanc | 11,68:1 |
| Rouge `#E82428` sur blanc | 4,45:1 — gros texte gras seulement |

- Le bleu ciel est **un fond sous du texte marine**, ou un filet. Jamais une couleur de texte sur blanc, jamais un fond sous du texte blanc.
- **Le rouge est réservé au statut « en direct » et à un CTA unique.** Pas de rouge décoratif : quand tout est rouge, « en direct » ne signifie plus rien.
- Tout texte atteint 4,5:1 minimum. Calculer, ne pas estimer.
- **Ne jamais utiliser `opacity` pour atténuer un état.** L'opacité dégrade indistinctement titre et texte secondaire — le secondaire tombe sous le seuil. Piloter les couleurs explicitement : titre `#3E4A5C` (8,98:1), secondaire `#667080` (5,01:1).

## Cartes

Fond `#FFFFFF`, bordure `1px solid #E3E8F1`, rayon 12 px, padding `16px 18px`, 12 px entre cartes.
Filet gauche 3 px pleine hauteur : rouge si en direct, bleu ciel si à venir, `#C9D2E0` si terminé.
Ombre : `0 1px 2px rgba(7,54,118,.05), 0 6px 20px rgba(7,54,118,.05)`.

Ordre : ligne méta (horaire marine `tabular-nums`, pastille de statut, durée grise) → titre 16 px poids 500 `#0B2A52` → sous-ligne 13 px `#5E6B7E`.

**Le premium se reconnaît à la retenue.** Pas d'aplat saturé pleine largeur, pas de dégradé, pas d'ombre lourde. La hiérarchie vient de la typographie et du blanc tournant.

## Statuts

Six états, distingués par **remplissage, contour et couleur de texte** — jamais par opacité.

| Statut | Traitement |
|---|---|
| En direct | rouge plein, texte blanc |
| Retard | contour `#E82428`, fond blanc, texte `#B71C1F` |
| Bientôt | `#EAF4FC` / `#0B4C7A` |
| Terminé | `#F1F3F7` / `#4A5568` |
| Déplacé | marine plein, texte blanc |
| Annulé | neutre + titre barré |

Forme : `padding:3px 9px`, `border-radius:20px`, 11 px, poids 500.

## Mouvement

Guide consulté au téléphone, dans un hall de convention, par quelqu'un qui cherche où aller. **L'animation retarde la lecture.**

Autorisé : retour tactile (~120 ms), ouverture d'accordéon, pulsation du badge « en direct ». Rien d'autre. Toujours derrière `prefers-reduced-motion`.

## Cible

90 % de lecture mobile après scan d'un QR code. Tester à 375 px en priorité. Zones tactiles ≥ 44 px. Lisibilité en plein soleil : c'est ce qui justifie les seuils de contraste ci-dessus.

## Avant tout commit

1. Ouvrir `index.html` en local, parcourir les 4 journées en FR et EN.
2. Console (F12) : **zéro erreur**. Une accolade orpheline a déjà cassé tout le script une fois — plus rien ne s'affichait et la page ne défilait plus.
3. Réseau : la requête vers `api.jsonbin.io` renvoie 200.
4. Le splash s'affiche 2 s, puis la page reste défilable.
5. Rendu à 375 px.
6. `git diff` : rien en dehors du périmètre annoncé.

## Dette connue

Le fichier porte deux systèmes de style empilés — la feuille d'origine, puis un bloc de refonte qui la surcharge avec des `!important`. Arbitrage assumé : la convention est en septembre, ce n'est pas un projet à maintenir des années. Ne pas aggraver : toute règle nouvelle puise dans `--brand-*`.

Image du Roi : 340×627 (1×), floue sur écran retina, et son titre incrusté se superpose au libellé de la carte. À remplacer par une source propre en 680×1254, JPEG q80 progressif, < 150 Ko.
