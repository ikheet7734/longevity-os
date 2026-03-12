#!/usr/bin/env node
/**
 * Capture dashboard screenshots for README showcase.
 * Uses Playwright to take section-by-section screenshots.
 */
import { chromium } from 'playwright';
import { mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const SCREENSHOT_DIR = join(__dirname, 'screenshots');
mkdirSync(SCREENSHOT_DIR, { recursive: true });

const URL = 'http://localhost:8420';

async function main() {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 } });

  await page.goto(URL, { waitUntil: 'networkidle' });
  // Wait for Chart.js to render
  await page.waitForTimeout(3000);

  // Get full page dimensions
  const pageHeight = await page.evaluate(() => document.documentElement.scrollHeight);

  // 1. Full page screenshot
  await page.screenshot({
    path: join(SCREENSHOT_DIR, 'dashboard-full.png'),
    fullPage: true,
  });
  console.log('✓ Full page screenshot');

  // 2. Hero section (header + agent bar + summary cards + nutrition top)
  await page.screenshot({
    path: join(SCREENSHOT_DIR, 'dashboard-hero.png'),
    fullPage: true,
    clip: { x: 0, y: 0, width: 1440, height: 500 },
  });
  console.log('✓ Hero section');

  // Helper: get bounding box of Nth div.section (0-indexed)
  async function getSectionBox(index) {
    return await page.evaluate((idx) => {
      const sections = document.querySelectorAll('div.section');
      if (idx < sections.length) {
        const rect = sections[idx].getBoundingClientRect();
        const scrollY = window.scrollY || document.documentElement.scrollTop;
        return {
          x: rect.x,
          y: rect.y + scrollY,
          width: rect.width,
          height: rect.height,
        };
      }
      return null;
    }, index);
  }

  // Section indices: 0=Summary, 1=Nutrition, 2=Body Metrics, 3=Exercise,
  //                  4=Supplements, 5=Biomarkers, 6=Trials, 7=Insights
  const sections = [
    { index: 0, name: 'summary', label: "Today's Summary" },
    { index: 1, name: 'nutrition', label: 'Nutrition' },
    { index: 2, name: 'metrics', label: 'Body Metrics' },
    { index: 3, name: 'exercise', label: 'Exercise' },
    { index: 4, name: 'supplements', label: 'Supplements' },
    { index: 5, name: 'biomarkers', label: 'Biomarkers' },
    { index: 6, name: 'trials', label: 'Trials' },
    { index: 7, name: 'insights', label: 'Insights' },
  ];

  for (const sec of sections) {
    const box = await getSectionBox(sec.index);
    if (box && box.width > 0 && box.height > 0) {
      const x = Math.max(0, box.x - 10);
      const y = Math.max(0, box.y - 10);
      const w = Math.min(1440, box.width + 20);
      const h = Math.min(pageHeight - y, box.height + 20, 900);
      if (w > 0 && h > 0) {
        await page.screenshot({
          path: join(SCREENSHOT_DIR, `dashboard-${sec.name}.png`),
          fullPage: true,
          clip: { x, y, width: w, height: h },
        });
        console.log(`✓ ${sec.label} (${Math.round(box.height)}px)`);
      }
    } else {
      console.log(`✗ ${sec.label} not found`);
    }
  }

  await browser.close();
  console.log('\nAll screenshots saved to docs/screenshots/');
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
