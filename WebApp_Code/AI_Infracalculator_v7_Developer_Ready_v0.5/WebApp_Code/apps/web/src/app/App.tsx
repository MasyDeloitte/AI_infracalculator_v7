import { useState } from 'react';
import type { Page } from './types';
import { LandingPage } from '@/pages/landing/LandingPage';
import { ExecutiveInputsPage } from '@/pages/inputs/ExecutiveInputsPage';
import { BomFinancialsPage } from '@/pages/bom/BomFinancialsPage';
export function App(){const[page,setPage]=useState<Page>('landing'); if(page==='landing')return <LandingPage setPage={setPage}/>; if(page==='inputs')return <ExecutiveInputsPage setPage={setPage}/>; return <BomFinancialsPage setPage={setPage}/>;}
