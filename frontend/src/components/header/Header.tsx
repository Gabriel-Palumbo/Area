import React from 'react';
import styles from './Header.module.css';

const Header = () => {
    return (
        <header className={styles.header}>
            <h2 className={styles.navLink}>Lk1</h2>
            <h2 className={styles.navLink}>Lk2</h2>
            <h2 className={styles.navLink}>Lk3</h2>
            <h2 className={styles.navLink}>Lk4</h2>
            <h2 className={styles.navLink}>Lk5</h2>
        </header>
    );
};

export default Header;
